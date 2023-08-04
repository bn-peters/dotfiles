#! /usr/bin/env python3

import re
import subprocess

REGEX = re.compile("layout:\s*([\w]*)")
setxkbmap = subprocess.check_output(["setxkbmap", "-query"]).decode("ASCII")

result = REGEX.search(setxkbmap)
layout = result.group(1)

if layout == "us":
    subprocess.check_output(["setxkbmap", "de", "-option", "caps:swapescape"])
else:
    subprocess.check_output(["setxkbmap", "us", "-variant", "altgr-intl", "-option", "caps:swapescape"])
