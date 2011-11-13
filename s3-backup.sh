#!/bin/zsh
# Copyright muflax <mail@muflax.com>, 2011
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

S3=s3://backup.muflax.com     

echo "Compressing ~/spoiler..."
mkdir -p $HOME/spoiler-backup
cd $HOME/spoiler-backup
tar -vczf spoiler.tar.gz ~/spoiler --exclude ~/spoiler/archive/www
split --line-bytes=100M spoiler.tar.gz spoiler.tar.gz_
rm spoiler.tar.gz

echo "Backuping up to $S3..."
read
s3cmd del -r $S3/spoiler-backup
s3cmd sync --delete-removed ~/spoiler-backup $S3/

echo "Cleaning up..."
rm -rf $HOME/spoiler-backup

echo "Backup done."
