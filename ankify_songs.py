#!/usr/bin/env python
# muflax <muflax@gmail.com>, GPL 3.0

"""
Reads in .txt files and formats them for cloze deletion, with 2 lines of context
before and after. It regards every line as one item.
"""

import re, sys

def main():
    for song in sys.argv[1:]:
        with open(song, "r") as f:
            # read in lines
            fl = []
            for i, line in enumerate(f, 1):
                entry = "%d: %s" % (i, line.strip())
                fl.append(entry)
            
            tag = " "+re.sub(".txt$", "", song)
    
            # process lines, output tsv
            linebreak = "<br/>"
            # reversed because training from unknown -> known is easier
            for n in reversed(range(len(fl))):
                # skip empty lines
                if re.search("^[0-9]+:\s*$", fl[n]): 
                    continue

                before = linebreak.join( fl[max(0, n-2):n] )
                answer = "<span style='color:#0000ff;'>%s</span>" % (fl[n])
                after = linebreak.join(fl[n+1:min(len(fl), n+3)])

                print "\t".join((before, answer, after, tag))

if __name__=="__main__":
    main()
