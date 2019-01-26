# -*- coding: utf-8 -*-
"""
WebSearch using shortcuts
"""

import json
import os.path
import webbrowser
from albertv0 import Item, iconLookup, FuncAction, configLocation


__iid__ = "PythonInterface/v0.2"
__prettyname__ = "Web Search"
__version__ = "0.1"
__trigger__ = "!"
__author__ = "Reetobrata Chatterjee"
__dependencies__ = []


def make_item(engine, query=None):
    if query is not None:
        return Item(
            text=query,
            subtext=engine["name"],
            icon=iconLookup(engine["icon"]),
            actions=[
                FuncAction(
                    "Search {}".format(engine["name"]),
                    lambda: webbrowser.open(engine["search"].format(query)),
                )
            ],
        )
    else:
        return Item(
            text=engine["shortcut"],
            subtext=engine["name"],
            icon=iconLookup(engine["icon"]),
        )


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


def fuzzy_list(shortcut, engines):
    engine_l = []
    for engine in engines:
        score = fuzzy_match(shortcut, engine["shortcut"])
        if score < 0:
            continue
        else:
            engine_l.append((engine, score))

    return [i[0] for i in sorted(engine_l, key=lambda i: i[1])]


def handleQuery(query):
    engines = None
    with open(os.path.join(configLocation(), "websearch/engines.json")) as f:
        engines = json.load(f)

    if query.isTriggered and query.isValid:
        q = query.string.split(" ")
        if len(q) == 0:
            return [make_item(e) for e in engines]

        fz = fuzzy_list(q[0], engines)
        if len(fz) == 0:
            return []
        if len(fz) == 1 and len(q) > 1 and q[1] != "":
            return [make_item(fz[0], query=" ".join(q[1:]))]
        else:
            return [make_item(e) for e in fz]

    return []
