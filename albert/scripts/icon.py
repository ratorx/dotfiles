# -*- coding: utf-8 -*-
"""
iconlookup with albert
"""

from albertv0 import Item, iconLookup, ProcAction, info


__iid__ = "PythonInterface/v0.1"
__prettyname__ = "Icon Lookup"
__version__ = "0.1"
__trigger__ = "icon "
__author__ = "Reetobrata Chatterjee"
__dependencies__ = []


def handleQuery(query):
    if query.isTriggered:
        stripped = query.string
        if stripped.startswith(__trigger__):
            stripped = query.string[len(__trigger__) :]
        return [Item(text=iconLookup(stripped), icon=iconLookup(stripped))]
