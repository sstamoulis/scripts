#!/bin/zsh
# Copyright muflax <mail@muflax.com>, 2011
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

S3=s3://backup.muflax.com     

echo "Compressing ~/spoiler..."
mkdir -p $HOME/spoiler-backup
cd $HOME/spoiler-backup

# compress
tar -vczf spoiler.tar.gz ~/spoiler --exclude ~/spoiler/archive/www

# encrypt
gpg -r muflax -cev --batch --passphrase-file ~/.s3_passphrase spoiler.tar.gz
rm spoiler.tar.gz

# split for easier transfer
split --line-bytes=100M spoiler.tar.gz.gpg spoiler.tar.gz.gpg_

echo "Backuping up to $S3..."
s3cmd del -r $S3/spoiler-backup
s3cmd sync --delete-removed ~/spoiler-backup $S3/

echo "Cleaning up..."
rm -rf $HOME/spoiler-backup

echo "Backup done."
