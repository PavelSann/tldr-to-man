#!/bin/sh

DIR="$(realpath "$0")"
DIR="$(dirname "$DIR")"
cd "$DIR" || exit

cd tldr && git pull && ../convert.sh
