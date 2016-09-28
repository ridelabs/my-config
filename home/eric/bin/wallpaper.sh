#!/bin/bash

source=~/Pictures/Wallpaper
export bg=$(find "$source" -maxdepth 1 -mindepth 1 -type f -print0 \
  | sort --zero-terminated --random-sort \
        | sed 's/\d000.*//g')
feh --no-fehbg --bg-max "$bg"


