#!/bin/bash

function itemInList {

	local list="$1"
	local item="$2"

	if [[ $list =~ (^|[[:space:]])"$item"($|[[:space:]]) ]]
	then
		# yes, list include item
		result=0
	else
		result=1
	fi
	# echo "$list _ $item _ $result" 
	return $result
}

function check(){

	local path="$1"
	local list=$(echo $2 | tr ',' ' ')

	by=$(sed -n 6p $path | awk '{print $3}')
	mail=$(sed -n 6p $path | awk '{print $4}' | tr '<' ' ' | tr '@' ' ' | awk '{print $1}')
	Created=$(sed -n 8p $path | awk '{print $6}')
	Updated=$(sed -n 9p $path | awk '{print $6}')
	itemInList "$list" "$by"
	b=$?
	itemInList "$list" "$mail"
	m=$?
	itemInList "$list" "$Created"
	c=$?
	itemInList "$list" "$Updated"
	u=$?

	((b)) && result="by: $by\n"
	((m)) && result+="mail: $mail\n"
	((c)) && result+="Created: $Created\n"
	((u)) && result+="Updated: $Updated\n"

	printf "$path"
	(($result == "0")) && printf "\e[32m [OK]\e[0m\n" || printf "\e[31m$result\e[0m\n"
	# echo $x
	# exit
	# echo $by
	# echo $mail
	# echo $Created
	# echo $Updated
	# if [ "$by" = "$USER" ]; then
	# 	printf "\e[32m $path: $USER\e[0m\n"
	# else
	# 	printf "\e[31m $path: $by\e[0m\n"
	# fi
	# USER=$(sed -n -e 6p -e 8,9p $1) #| awk '{print $2, $3, $4, $5, $6}'
	# USER=$(sed -n -e 6p -e 8,9p $1) #| awk '{print $2, $3, $4, $5, $6}'
}

echo -n "Enter the project directory, default [.]: "

read DIR

[ -z "$DIR" ] && DIR=$(dirname -- "$0")

UL=$USER
echo -n "Enter developers list: ${UL},"
read TT

UL+=",${TT}"


FILELIST=$(find ${DIR} -type f | grep -e '\.c$' -e '\.cpp$' -e '\.h$' -e '\.hpp$') 

i=1

FILECOUNT=$(echo $FILELIST | tr ' ' '\n' | wc -l)

until [ $i -gt $FILECOUNT ]
do
	check $(echo $FILELIST | cut -d " " -f $i) $UL
	((i=i+1))
done
