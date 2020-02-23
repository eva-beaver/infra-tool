#!/usr/bin/env bash

OIFS=$IFS
IFS=$'\n'
array=($(<testfile.txt))
IFS=$OIFS

for i in "${array[@]}"
do
	echo $i
done