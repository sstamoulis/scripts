#!/usr/bin/python -O
import os, glob, sys

s, v, a = sys.argv[1:4]
g = glob.glob("*.mkv")
g.sort()
for f in g:
    ss = "%s_%02d" % (s, g.index(f)+1)
    os.system("mkvextract tracks '%s' %s:%s %s:%s" % (f,
        v, ss+".video", a, ss+".audio"))
    os.system("mkvmerge -o %s %s %s" % (ss+".mkv", ss+".video", ss+".audio"))
    os.system("rm %s %s" % (ss+".video", ss+".audio"))
