#!/bin/bash


function itemInList {

	local list="$1"
	local item="$2"

	if [[ $list =~ (^|[[:space:]])"$item"($|[[:space:]]) ]]
	then
		# yes, list include item
		return 0
	else
		return 1
	fi
}

function check(){

	local path="$1"
	local list=$(echo $2 | tr ',' ' ')

	by=$(sed -n 6p $path | awk '{print $3}')
	mail=$(sed -n 6p $path | awk '{print $4}' | tr '<' ' ' | tr '@' ' ' | awk '{print $1}')
	Created=$(sed -n 8p $path | awk '{print $6}')
	Updated=$(sed -n 9p $path | awk '{print $6}')

	[[ -z "$by" || -z "$mail" || -z "$Created" || -z "$Updated" ]] && out+="\e[33m$path: [KO] No header!\n$result\e[0m\n" && return 1

	itemInList "$list" "$by"
	b=$?
	itemInList "$list" "$mail"
	m=$?
	itemInList "$list" "$Created"
	c=$?
	itemInList "$list" "$Updated"
	u=$?

	result=""
	# printf "\n$b\t$m\t$c\t$u\n"
	((b)) && result="by: $by\n"
	((m)) && result+="mail: $mail\n"
	((c)) && result+="Created: $Created\n"
	((u)) && result+="Updated: $Updated\n"

	[[ -z "$result" ]] && printf "\e[32m$path: [OK]\e[0m\n" || out+="\e[31m$path: [KO]\n$result\e[0m\n"
	# echo $result
	# exit
	# echo $by
	# echo $mail
	# echo $Created
	# echo $Updated
}

out=""

echo -n "Enter the project directory, default [.]: "

read DIR

[ -z "$DIR" ] && DIR=$(dirname -- "$0")

UL=$USER
echo -n "Enter developers list: ${UL},"
read TT
TT=$(echo $TT | tr ' ' ',')
UL+=",marvin,${TT}"


FILELIST=$(find ${DIR} -type f | grep -e '\.c$' -e '\.cpp$' -e '\.h$' -e '\.hpp$') 

i=1

FILECOUNT=$(echo $FILELIST | tr ' ' '\n' | wc -l)

until [ $i -gt $FILECOUNT ]
do
	check $(echo $FILELIST | cut -d " " -f $i) $UL
	((i=i+1))
done

printf "$out"
