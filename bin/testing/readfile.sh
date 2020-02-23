#!/usr/bin/env bash

filename='docker-compose.tpl'

cat $filename | while read line 
do
   echo $line
done

while IFS="" read -r p || [ -n "$p" ]
do
  i=$[$i +1]
  #printf '%s\n' "$p"
  x=$(printf '%s\n' "$p")
  echo  "$i $x"
  dataArray[i]=$(printf '%s\n' "$p")
done < $filename

for data in "${dataArray[@]}"
do
	echo "------------$data"
done