#!/bin/zsh
# Copyright muflax <mail@muflax.com>, 2013
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

# sync all important git-annex repos
dirs=(~/books)

for dir in $dirs; do
  cd $dir
  git-annex get --auto
done
