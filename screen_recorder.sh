#!/bin/bash

if [[ $# -lt 1 ]]; then

   echo "Use $0 <output_filename>"

elif [[ $1 == "-h" ]]; then
   echo "Use $0 <output_filename>"

else
   resolution=`xrandr --verbose | grep 'connected primary'\
               | awk '{print $4}' | cut -d'+' -f1`

   echo "Resolution recorder: $resolution"

   echo -e "\n"

   for (( i = 5; i > 0; i-- )); do
      echo "Start recorder in $i sec."
      sleep 1 #delay for start recorder
   done

   ffmpeg -f x11grab -r 25 -s $resolution -i :0.0 -vcodec libx264 \
   -threads 4 $HOME/$1.avi
fi
