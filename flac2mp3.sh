#!/bin/zsh
# Copyright muflax <mail@muflax.com>, 2011
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

for flac in **/*.flac
do
  echo "converting $flac..."
  OUTF=$(echo "$flac" | sed s/\.flac$/.mp3/g)

  ARTIST=$(metaflac "$flac" --show-tag=ARTIST | sed "s/.*=//g")
  echo "artist: $ARTIST"
  TITLE=$(metaflac "$flac" --show-tag=TITLE | sed "s/.*=//g")
  echo "title: $TITLE"
  ALBUM=$(metaflac "$flac" --show-tag=ALBUM | sed "s/.*=//g")
  echo "album: $ALBUM"
  GENRE=$(metaflac "$flac" --show-tag=GENRE | sed "s/.*=//g")
  echo "genre: $GENRE"
  TRACKNUMBER=$(metaflac "$flac" --show-tag=TRACKNUMBER | sed "s/.*=//g")
  echo "track: $TRACKNUMBER"
  DATE=$(metaflac "$flac" --show-tag=DATE | sed "s/.*=//g")
  echo "date: $DATE"

  flac -c -d "$flac" | lame --replaygain-fast -V0 \
    --add-id3v2 --pad-id3v2 --ignore-tag-errors --tt "$TITLE" --tn \
    "${TRACKNUMBER:-0}" --ta "$ARTIST" --tl "$ALBUM" --ty "$DATE" --tg \
    "${GENRE:-12}" - "$OUTF"

  RESULT=$?
  if [ "$1" ] && [ "$1" = "-d" ] && [ $RESULT -eq 0 ]; then
    rm "$flac"
  fi

done
