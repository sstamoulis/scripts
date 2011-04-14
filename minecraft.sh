#!/bin/zsh
# Copyright muflax <mail@muflax.com>, 2010
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

# disable scim
export GTK_IM_MODULE=""
export QT_IM_MODULE=""
export XMODIFIERS=@im=""

# rotate textures
#cd $HOME/.minecraft/bin
#java -jar "Minecraft Texture Rotator.jar"

# start minecraft
JAR="$HOME/local/opt/minecraft/Minecraft.jar"
java -Xmx2048M -Xms2048M -cp $JAR net.minecraft.LauncherFrame
