# -*- coding: utf-8 -*-
"""
Manage VPNs using nmcli
"""

import subprocess
from shutil import which
from collections import namedtuple

from albertv0 import Item, iconLookup, ProcAction


__iid__ = "PythonInterface/v0.1"
__prettyname__ = "Network Manager VPN"
__version__ = "0.1"
__trigger__ = "vpn "
__author__ = "Reetobrata Chatterjee"
__dependencies__ = ["networkmanager", "networkmanager-openvpn"]

if which("nmcli") is None:
    raise Exception("'nmcli' is not in $PATH.")

Connection = namedtuple("Connection", ["name", "id", "type", "interface"])
NET_ICON = iconLookup("preferences-system-network")


def get_vpns():
    vpns = []
    for line in (
        subprocess.check_output(["nmcli", "-t", "c", "show"])
        .decode("utf-8")
        .splitlines()
    ):
        conn = Connection(*(line.split(":")))
        if conn.type == "vpn":
            vpns.append(conn)

    return vpns


def make_vpn_item(vpn):
    subtext = None
    actions = []
    if vpn.interface == "":
        subtext = "VPN"
        actions.append(ProcAction("Connect", ["nmcli", "-t", "c", "up", vpn.id]))
    else:
        subtext = "Connected - VPN"
        actions.append(ProcAction("Disconnect", ["nmcli", "-t", "c", "down", vpn.id]))
    return Item(text=vpn.name, subtext=subtext, actions=actions, icon=NET_ICON)


def fuzzy_match(query, text):
    i = 0
    j = 0
    while i != len(query) and j != len(text):
        if query[i] == text[j]:
            i += 1
            j += 1
        else:
            j += 1

    if i == len(query):
        return j - i
    else:
        return -1


def handleQuery(query):
    if query.isTriggered and query.isValid:
        q = query.string.strip().lower()
        vpns = get_vpns()
        result = []
        for vpn in vpns:
            if not query.isValid:
                return []

            if vpn.interface != "":
                return [make_vpn_item(vpn)]

            score = fuzzy_match(q, vpn.name.lower())
            if score < 0:
                continue
            result.append((make_vpn_item(vpn), score))

        return [item[0] for item in sorted(result, key=lambda x: x[1])]

    return []
