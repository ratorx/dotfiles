# -*- coding: utf-8 -*-
"""
Manage NordVPN
"""

import subprocess
from shutil import which

from albertv0 import Item, ProcAction, iconLookup

__iid__ = "PythonInterface/v0.1"
__prettyname__ = "NordVPN"
__version__ = "0.1"
__trigger__ = "vpn "
__author__ = "Reetobrata Chatterjee"
__dependencies__ = ["nordvpn"]

if which("nordvpn") is None:
    raise Exception("'nordvpn' is not in $PATH.")


NET_ICON = iconLookup("preferences-system-network")


def get_connected_status():
    conn = {}
    for line in (
        subprocess.check_output(["nordvpn", "status"]).decode("utf-8").splitlines()
    ):
        split = line.split(": ")
        if len(split) != 2:
            continue
        key, value = split[0].strip(), split[1].strip()
        conn[key.lower()] = value

    if conn["status"] == "Connected":
        return conn["country"]
    return None


def get_vpns():
    return [
        name.replace("_", " ")
        for name in subprocess.check_output(["nordvpn", "countries"])
        .strip()
        .decode("utf-8")
        .split()[1:]
    ]


def make_vpn_item(country_name, is_connected):
    subtext = None
    actions = []
    if is_connected:
        subtext = "Connected - VPN"
        actions.append(ProcAction("Disconnect", ["nordvpn", "disconnect"]))
    else:
        subtext = "VPN"
        actions.append(
            ProcAction(
                "Connect", ["nordvpn", "connect", country_name.replace(" ", "_")]
            )
        )
    return Item(text=country_name, subtext=subtext, actions=actions, icon=NET_ICON)


def fuzzy_match(query, text):
    i, j = 0, 0
    while i != len(query) and j != len(text):
        if query[i] == text[j]:
            i += 1
        j += 1

    if i == len(query):
        return j - i
    else:
        return -1


def handleQuery(query):
    if query.isTriggered and query.isValid:
        q = query.string.strip().lower()
        countries = get_vpns()
        result = []
        connected = get_connected_status()
        for country in countries:
            if not query.isValid:
                return []

            if country == connected:
                return [make_vpn_item(country, True)]

            score = fuzzy_match(q, country.lower())
            if score < 0:
                continue
            result.append((make_vpn_item(country, False), score))

        return [item[0] for item in sorted(result, key=lambda x: x[1])]

    return []
