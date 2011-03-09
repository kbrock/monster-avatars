#!/usr/bin/env bash

# currently only 3 attributes

if [ $# -ne 6 ] ; then
  echo "usage: create_face <body:1-15> <arm: 1-5> <eyes:1-15> <hair:1-5> <legs:1-5> <mouth 1-10>"
  exit 0
fi

body=$1
arm=$2
eyes=$3
hair=$4
legs=$5
mouth=$6

convert parts/background.png parts/legs_${legs}.png -composite parts/hair_${hair}.png -composite parts/arms_${arm}.png -composite parts/body_${body}.png -composite parts/eyes_${eyes}.png -composite parts/mouth_${mouth}.png -composite out.png
open out.png

#convert ../parts/background.png \( body_1.png -size 10x100 gradient:#ff00ff -clut \) -composite out.png
#convert body_1.png -size 10x100 gradient:#ffff00 -clut out.png && open out.png