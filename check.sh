#!/bin/bash

function check(){

	by=$(sed -n 6p $1 | awk '{print $3}')
	mail=$(sed -n 6p $1 | awk '{print $4}' | tr '<' ' ' | tr '@' ' ' | awk '{print $1}')
	Created=$(sed -n 8p $1 | awk '{print $6}')
	Updated=$(sed -n 9p $1 | awk '{print $6}')
	# echo $by
	# echo $mail
	# echo $Created
	# echo $Updated
	if [ "$by" = "$USER" ]; then
		printf "\e[32m$USER\e[0m\n"
	else
		printf "\e[31m$by\e[0m\n"
	fi
	# USER=$(sed -n -e 6p -e 8,9p $1) #| awk '{print $2, $3, $4, $5, $6}'
	# USER=$(sed -n -e 6p -e 8,9p $1) #| awk '{print $2, $3, $4, $5, $6}'
}

echo -n "Enter the project directory, default [.]: "

read DIR
echo -n "Enter users list: ${USER}, "
read UL

[ -z "$DIR" ] && DIR=$(dirname -- "$0")
[ -z "$UL" ] && UL=$USER

echo "--> $UL"
exit()
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
