#!/bin/sh -e

:>.contents

trap 'rm -f .contents' EXIT

for post in src/*.md; do
  nodir="${post#src/}"
  dest="${nodir%.md}.html"
  printf "generating %s\n" "$dest"
  pandoc -s --template _template.html -o "p/$dest" "$post"
  metadata="$(head -n 1 "p/$dest")"
  metadata="${metadata%-->}"
  metadata="${metadata#<!--}"
  printf "%s@@%s\n" "$metadata" "$dest" >>.contents
done

# TODO sort the .contents file
# use this to generate the site index
awk 'BEGIN {FS="@@"} {print $1" - <a href=\"p/"$3"\">"$2"</a>"}' .contents
