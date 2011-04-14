#!/bin/bash

for i in /var/lib/pacman/local/*; do
        PKG=`echo $i | cut -d '/' -f 6`
        SIZE=`grep -A 1 SIZE $i/desc | tail -1`
        if [ -x /usr/bin/bc ]; then
            SIZE=`echo "scale=1;$SIZE/1048576" | bc`M
        fi
        echo "$SIZE | $PKG"
done

