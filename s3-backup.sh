#!/bin/zsh
# Copyright muflax <mail@muflax.com>, 2011
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

S3=s3://backup.muflax.com

echo "Cloning ~/spoiler..."
git clone ~/spoiler ~/spoiler-backup

echo "Backuping up to $S3..."
s3cmd sync --delete-removed ~/spoiler-backup/ $S3/spoiler/
s3cmd sync --delete-removed ~/spoiler/mail/ $S3/spoiler/mail

echo "Deleting temp files..."
rm -vrf ~/spoiler-backup

echo "Backup done."
