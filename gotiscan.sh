#!/bin/bash
#
#Author: Jorge Garcia Bermejo

#Colors
greenColor="\e[0;32m\033[1m"
endColor="\033[0m\e[0m"
redColor="\e[0;31m\033[1m"
blueColor="\e[0;34m\033[1m"
yellowColor="\e[0;33m\033[1m"
purpleColor="\e[0;35m\033[1m"
turquoiseColor="\e[0;36m\033[1m"
grayColor="\e[0;37m\033[1m"

function ctrl_c() {
	echo -e "\n\n${redColor}[!]${endColor} Exiting..."
	exit 1
}

# Ctrl+c to trap to abort program at any point
trap ctrl_c INT

declare -a ports=("$(seq 1 65535)")

function checkPort() {

	(exec 3<>/dev/tcp/"$1"/"$2") 2>/dev/null

	if [ $? -eq 0 ]; then
		echo -e "\n${greenColor}[+]${endColor} Host $1 - Port $2 ${greenColor}OPEN${endColor}"
	fi

	exec 3<&-
	exec 3>&-
}

if [ "$1" ]; then
	for port in ${ports[@]}; do
		checkPort "$1" "$port" &
	done
else
	echo -e "\n${redColor}[!]${endColor} Use: $0 <ip-address>\n"
fi

wait
