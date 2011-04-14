#!/usr/bin/env python
# -*- coding: utf-8 -*-
import glob
for f in glob.glob("*.utf8.txt"):
    ff = open(f, "r")
    fn = open(f+".t", "w")
    for line in ff:
        s = line.split("\t")
        try:
            nl = "%s %s %s" % (s[0], "#KJ*500", s[1].replace(" ", "　"))
            fn.write(nl+"\n")
        except:
            continue

    fn.close()
    ff.close()

