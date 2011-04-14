#!/bin/zsh
# Copyright muflax <mail@muflax.com>, 2009
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>
        
# a bit unorganized, but whatever

LOCALREPO="local"

PACKAGES=($(pacman -Qq))

ORPHANS=0
for package in $PACKAGES
do
    echo -n "testing $package"
    
    ARCH=$(pacman -Qi $package | grep "Architecture" | awk '{ print $3 }')
    echo -n "...arch: $ARCH"

    REPO=$(pacman -Ss "^${package}$" | head -n 1 | grep -o -P "^\w+")
    if [[ -z $REPO ]] then
        echo -n "...foreign, trying to get info from AUR"
        # this is ugly, but we have to do 2 checks anyway, so i might as well
        # avoid as much parsing as possible
        JSON=$(wget -q -O - "http://aur.archlinux.org/rpc.php?type=info&arg=$(perl -MURI::Escape -e "print uri_escape('$package');" )")
        ID=$(echo $JSON | perl -pe 's/.*"ID":"(\d+)".*/$1/')
        if [[ -z $ID ]] then
            echo -n " --> not found. counting as orphan.\n"
            ORPHANS=$(($ORPHANS + 1))
            continue
        else
            MAINTAINER=$(lynx -dump "http://aur.archlinux.org/packages.php?ID=${ID}" | grep "Maintainer" | sed 's/\s*Maintainer:\s*//')
        fi
    else
        echo -n "...repo: $REPO"
        if [[ $REPO == $LOCALREPO ]] then
            echo -n " --> local, counting as orphan\n"
            ORPHANS=$(($ORPHANS + 1))
            continue
        fi
        
        MAINTAINER=$(lynx -dump "http://www.archlinux.org/packages/${REPO}/${ARCH}/${package}/" | grep "Maintainer" | sed 's/\s*Maintainer:\s*//')
    fi
        
    echo -n "...maintainer: $MAINTAINER"
    if [[ $MAINTAINER == "None" ]] then
        echo -n " --> orphan\n"
        ORPHANS=$(($ORPHANS + 1))
        continue
    fi
    echo -n " --> maintained\n"
done

echo "$ORPHANS orphan(s) found."
