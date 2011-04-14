import os, sys

if len(sys.argv) < 2:
    print("Usage: ftwin-rm.py list.txt [rm]")
    sys.exit(1)
l = open(sys.argv[1], "r")
a = [line.strip() for line in l]
try:
    if sys.argv[2] == "rm":
        pretend = False
    else:
        pretend = True
except:
    pretend = True

new_group = True
group = []
killed = 0
for line in a:
    if line:
        if new_group:
            group = [line]
            new_group = False
        else:
            group.append(line)
            #if pretend:
            #    print "kill:", line
            #else:
            #    os.remove(line)
    else:
        new_group = True
        for x in range(len(group)):
            if os.access(group[x], os.F_OK):
                group[x] = (os.stat(group[x]).st_size, group[x])
            else:
                group[x] = (0, group[x])
        group.sort()
        for f in group[:-1]:
            killed += 1
            if pretend:
                print("kill:",f[1])
            else:
                try:
                    os.remove(f[1])
                except:
                    pass

print("%dつを殺した。" % (killed))
