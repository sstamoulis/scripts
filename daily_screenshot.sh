#!/bin/zsh

format="%Y-%m-%d_%H-%M_$(hostname).jpg" 
exec="mv \$f $HOME/pigs/daily/"

[[ $(pidof X) > 0 ]] && DISPLAY=:0.0 scrot -m $format -q 30 -e "$exec"
