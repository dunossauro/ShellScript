#!/bin/bash

ip=`links -dump checkip.dyndns.org | grep "IP" | cut -f2 -d: | cut -f2 -d" "`

#o campo user deve ser preechido com o seu usuario
echo "$ip" > /home/<user>/Dropbox/inni.txt

echo "$ip"
