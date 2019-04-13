# -*- coding: utf-8 -*-
"""
X11 window switcher - list and activate windows.
"""

import subprocess
from collections import namedtuple
import os
from xdg import DesktopEntry
from shutil import which

from albertv0 import Item, iconLookup, ProcAction

Window = namedtuple("Window", ["wid", "desktop", "wm_class", "host", "wm_name"])

__iid__ = "PythonInterface/v0.1"
__prettyname__ = "Window Switcher"
__version__ = "1.2"
__trigger__ = "#"
__author__ = "Ed Perez, Manuel Schneider, Reeto Chatterjee"
__dependencies__ = ["wmctrl", "pyxdg"]

if which("wmctrl") is None:
    raise Exception("'wmctrl' is not in $PATH.")

iconMap = {}


def buildIconMap():
    # Scan global desktop entries
    def buildFromDir(d):
        with os.scandir(d) as it:
            for entry in it:
                if not entry.name.endswith(".desktop"):
                    continue
                desktopf = DesktopEntry.DesktopEntry(entry.path)
                icon = iconLookup(desktopf.getIcon())
                iconMap[entry.name[:-8].lower()] = icon  # Get rid of .desktop suffix
                wm_class = desktopf.getStartupWMClass()
                if wm_class != "":
                    iconMap[wm_class.lower()] = icon

    buildFromDir("/usr/share/applications")
    buildFromDir(os.path.expanduser("~/.local/share/applications"))


# TODO: Regularly refresh icon cache
buildIconMap()


def titlecase(s):
    return " ".join(word.capitalize() for word in s.split(" "))


def windowIconLookup(window, wm_class):
    return multipleIconLookup([wm_class[0], wm_class[1], window.wm_name])


def multipleIconLookup(identifiers):
    # Lookup icon using map
    icon = ""
    for ident in identifiers:
        icon = iconMap.get(ident.strip().lower(), "")
        if icon != "":
            return icon

    # Fallback to trying wm_class and wm_name directly
    for ident in identifiers:
        icon = iconLookup(ident.strip().lower())
        if icon != "":
            return icon
    return icon


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
    if query.isTriggered:
        stripped = query.string
        if stripped.startswith(__trigger__):
            stripped = query.string[len(__trigger__) :]
        stripped = stripped.strip().lower()
        results = []
        for line in subprocess.check_output(["wmctrl", "-l", "-x"]).splitlines():
            if not query.isValid:
                return []
            win = Window(*[token.decode() for token in line.split(None, 4)])
            wm_class = win.wm_class.split(".")
            if win.desktop != "-1" and wm_class[0] != "albert":
                score = fuzzy_match(stripped, " ".join(wm_class).lower())
                if score >= 0:
                    results.append(
                        (
                            Item(
                                id="%s%s" % (__prettyname__, win.wm_class),
                                icon=windowIconLookup(win, wm_class),
                                text="%s  - <i>Workspace %s</i>"
                                % (
                                    titlecase(wm_class[-1].replace("-", " ")),
                                    int(win.desktop) + 1,
                                ),
                                subtext=win.wm_name,
                                actions=[
                                    ProcAction(
                                        "Focus Window", ["wmctrl", "-ia", win.wid]
                                    ),
                                    ProcAction(
                                        "Close Window", ["wmctrl", "-ic", win.wid]
                                    ),
                                ],
                            ),
                            score,
                        )
                    )
        return [item[0] for item in sorted(results, key=lambda x: x[1])]
