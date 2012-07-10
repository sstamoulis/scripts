#!/bin/zsh
# Copyright muflax <mail@muflax.com>, 2012
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

# Simple Twitter backup script

source ~/.zsh/env.sh
source ~/.zsh/path.sh

DAY=$(date +'%Y-%m-%d')
DIR="/home/amon/spoiler/archive/twitter/"

mkdir -p $DIR

echo "Backing up tweets..."
twitter timeline @muflax --csv --number 3000 > $DIR/tweets-$DAY.csv
echo "Backing up retweets..."
twitter retweets --csv --number 3000 > $DIR/retweets-$DAY.csv
echo "Backing up favorites..."
twitter favorites --csv --number 3000 > $DIR/favorites-$DAY.csv
echo "Backing up DM received..."
twitter direct_messages --csv --number 3000 > $DIR/dm_received-$DAY.csv
echo "Backing up DM sent..."
twitter direct_messages_sent --csv --number 3000 > $DIR/dm_sent-$DAY.csv
echo "Backing up followings..."
twitter followings --csv > $DIR/followings-$DAY.csv
echo "Backing up followers..."
twitter followers --csv > $DIR/followers-$DAY.csv

echo "Compressing backups..."
gzip -f -9 $DIR/*.csv
