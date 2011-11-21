#!/bin/zsh
# Copyright muflax <mail@muflax.com>, 2011
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

# paths
export PATH="$($HOME/in/scripts/extend_path.sh):$PATH"
export GEM_HOME="$HOME/local/gems"
export GEM_PATH="$GEM_HOME"
export PATH="$GEM_HOME/bin:$PATH"
export LANG=ja_JP.UTF-8

firefox-urls | backup-urls >/dev/null
