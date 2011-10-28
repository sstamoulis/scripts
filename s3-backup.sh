#!/bin/zsh
# Copyright muflax <mail@muflax.com>, 2011
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

S3=s3://backup.muflax.com

echo "Backuping up to $S3..."
s3cmd sync --delete-removed ~/spoiler/ $S3/spoiler/

echo "Backup done."
