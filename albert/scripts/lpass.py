# -*- coding: utf-8 -*-
"""
Password lookup with Lastpass
"""

import json
import subprocess

from albertv0 import Item, iconLookup, ClipAction


__iid__ = "PythonInterface/v0.1"
__prettyname__ = "LastPass"
__version__ = "0.1"
__trigger__ = "pass "
__author__ = "Reetobrata Chatterjee"
__dependencies__ = ["lastpass-cli"]

lastpass = iconLookup("lastpass")


class Entry:
    def __init__(self, d):
        self.name = d["name"]
        self.username = d["username"]
        self.password = d["password"]

    @property
    def ident(self):
        return " ".join((self.name, self.username))

    def matches(self, query):
        i = 0
        j = 0
        text = self.ident
        while i != len(query) and j != len(text):
            if query[i] == text[j]:
                i += 1
                j += 1
            else:
                j += 1

        if i == len(query):
            return j - 1
        else:
            return -1

    @property
    def item(self):
        actions = [ClipAction("Copy password", self.password)]
        return Item(
            text=self.name, subtext=self.username, actions=actions, icon=lastpass
        )


def handleQuery(query):
    if query.isTriggered:
        stripped = query.string
        if stripped.startswith(__trigger__):
            stripped = query.string[len(__trigger__) :]
        entries = json.loads(
            subprocess.check_output(["lpass", "show", "-xjG", ""]), object_hook=Entry
        )
        items = []
        for entry in entries:
            e = entry.matches(stripped)
            if e != -1:
                items.append((entry.item, e))

        items.sort(key=lambda x: x[1])
        return [item[0] for item in items]
