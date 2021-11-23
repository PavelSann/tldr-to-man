#!/bin/sh

DIR="$(realpath "$0")"
DIR="$(dirname "$DIR")"
cd "$DIR" || exit

git clone https://github.com/tldr-pages/tldr.git && convert.sh