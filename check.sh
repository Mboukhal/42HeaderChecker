#!/bin/bash

function check(){

	# echo $1
	sed -n -e 8,9p $1
}

echo -n "Enter the project directory, default [.]: "

read DIR

[ -z "$DIR" ] && DIR=$(dirname -- "$0")

FILELIST=$(find ${DIR} -type f | grep -e '\.c' -e '\.cpp' -e '\.h' -e '\.hpp') 

i=1

FILECOUNT=$(echo $FILELIST | tr ' ' '\n' | wc -l)

echo 

until [ $i -gt $FILECOUNT ]
do
	echo $FILELIST | cut -d " " -f $i
	check $(echo $FILELIST | cut -d " " -f $i)
	((i=i+1))
done

