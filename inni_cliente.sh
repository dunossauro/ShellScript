#!/bin/bash

#get arquivo gerado no dropbox com o IP
wget https://www.dropbox.com/s/f80y7s5qxzeof7y/inni.txt

ip=`cat ./inni.txt`

echo "Conectando usando ao usuario $1 de $ip"

ssh $1@$ip
