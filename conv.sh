#!/bin/sh -e

printf "generating %s\n" "$2"
pandoc -s --template _template.html -o "$2" "$1"
