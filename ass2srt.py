#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys, re

def main(args):
    for filename in args:
        print(("converting", filename))
        f = open(filename, "r")
        srtf = open(filename+".srt", "w")
        
        index = 0
        for line in f:
            if line[:9] == "Dialogue:":
                #format: index \n start --> end \n text \n\n
                srtf.write("%d\n" % (index))
                index += 1

                clean_line = re.sub("{.*?}", "", line)
                entries = clean_line[10:].strip().split(",")
                srtf.write("%s --> %s\n" % (entries[1].replace(".",",")+"0", entries[2].replace(".",",")+"0"))
                srtf.write(re.sub(r'(?i)\\n','\n',"".join(entries[9:]))+"\n")
                srtf.write("\n")

        f.close()
        srtf.close()

if __name__ == "__main__":
    main(sys.argv[1:])
