#!/bin/sh -e

:>.contents

trap 'rm -f .contents' EXIT

for post in src/*.md; do
  nodir="${post#src/}"
  dest="${nodir%.md}.html"
  printf "generating entry: %s\n" "$dest"
  pandoc -s --template gen/entry.html -o "p/$dest" "$post"
  metadata="$(head -n 1 "p/$dest")"
  metadata="${metadata%-->}"
  metadata="${metadata#<!--}"
  printf "%s@@%s\n" "$metadata" "$dest" >>.contents
done

printf "generating index.html\n"
sort -r .contents \
  | awk 'BEGIN {FS="@@"} {print $1" - <a href=\"p/"$3"\">"$2"</a><br/>"}' \
  | cat gen/index_pre.html - gen/index_post.html >index.html
