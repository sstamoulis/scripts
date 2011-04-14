#!/usr/bin/python -O
import os, glob, sys

s, v, a = sys.argv[1:4]
g = glob.glob("*.ogm")
g.sort()
for f in g:
    ss = "%s_%02d" % (s, g.index(f)+1)
    os.system("ogmdemux -o %s -d %s -a %s '%s'" % (ss,
        v, a, f))
    os.system("mkvmerge -o %s %s %s" % (ss+".mkv", ss+"-v*", ss+"-a*"))
    os.system("rm %s %s %s" % (ss+"-v*", ss+"-a*", ss+"-t*"))
