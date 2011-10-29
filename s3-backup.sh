#!/bin/zsh
# Copyright muflax <mail@muflax.com>, 2011
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

S3=s3://backup.muflax.com     

echo "Compressing ~/spoiler..."
tar -vczf ~/spoiler.tar.gz ~/spoiler             

echo "Backuping up to $S3..."
s3cmd sync --delete-removed ~/spoiler.tar.gz $S3/

echo "Cleaning up..."
rm ~/spoiler.tar.gz

echo "Backup done."
