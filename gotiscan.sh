#!/bin/bash

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

####################################    GLOBAL VARS   ####################################

declare -a ports=("$(seq 1 65535)")
ip=""

function helpme() {
	echo -e "${greenColor}"
	cat <<"E0F"

                  __   _                         
   ____ _ ____   / /_ (_)_____ _____ ____ _ ____ 
  / __ `// __ \ / __// // ___// ___// __ `// __ \
 / /_/ // /_/ // /_ / /(__  )/ /__ / /_/ // / / /
 \__, / \____/ \__//_//____/ \___/ \__,_//_/ /_/ 
/____/                                           
 ______ ______ ______ ______ ______ ______ ______
/_____//_____//_____//_____//_____//_____//_____/
E0F
	echo -e "${endColor}"

	echo -e "\nOnly the following flags are available:"
	printf "\n\t${greenColor}[+]${endColor} -h | --help" "Shows help menu"
	printf "\n\t${greenColor}[+]${endColor} -v | --verbose" "Executes the script in more detail (verbose)"
	printf "\n\t${greenColor}[+]${endColor} -i | --ip-scan <IP>" "Takes the Target IP as argument"
}

####################################     FUNCTIONS    ####################################

function checkPort() {
	(exec 3<>/dev/tcp/$1/$2) 2>/dev/null

	if [ $? -eq 0 ]; then
		echo -e "\n${greenColor}[+]${endColor} Host $1 - Port $2 ${greenColor}OPEN${endColor}"
	fi

	exec 3<&-
	exec 3>&-
	wait
}

function portScan() {
	if [ "$1" ]; then
		for port in ${ports[@]}; do
			checkPort "$1" "$port" &
		done
	else
		echo -e "\n${redColor}[!]${endColor} Use: $0 <ip-address>\n"
	fi
}

####################################     GET OPTS     ####################################

OptShort="hvi:"
OptLong="help,verbose,ip-scan"
Opts=$(getopt -o $OptShort --long $OptLong -n "$(basename $0)" -- "$@")
eval set -- "$Opts"
while [ $# -gt 0 ]; do
	case "$1" in
	#HELPME_START
	#SYNOPSIS
	#	gotiscan [OPTION]...
	#DESCRIPTION
	-h | --help) #print help information
		helpme
		shift
		break
		;;
	-v | --verbose) #verbose output
		set -x
		shift
		;;
	-i | --ip-scan) #scans ports of the IP passed by argument
		portScan $2
		shift 2
		break
		;;
	--)
		shift
		break
		;;
	*)
		break
		;;
		#AUTHOR
		# Garcia Bermejo, Jorge
		#HELPME_END
	esac
done
