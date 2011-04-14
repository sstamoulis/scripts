#!/bin/zsh

MOZDIR="${HOME}/.mozilla"

cd $MOZDIR

if [[ ! -e firefox/.unpacked ]]; then
    #echo "first start, restoring backup..."
    rsync -a --delete-before firefox_bak/ firefox/ 
else
    #echo "saving data..."
    rsync -a --delete-before firefox_bak/ firefox_old_bak/ 
    rsync -a --delete-before firefox/ firefox_bak/ 
fi
