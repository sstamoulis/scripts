#!/bin/zsh
# Copyright muflax <mail@muflax.com>, 2010
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

PATH="$HOME/local/src/in/scripts:$HOME/local/bin"
# adding all subdirs of scripts, too
for dir in $HOME/local/src/in/scripts/**/*(/); do
  PATH="$dir:$PATH"
done

echo $PATH
