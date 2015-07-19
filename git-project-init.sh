#!/bin/bash

LICENCE_DIR="./licences"

if [[ ! $1 = "" ]]; then
	projectName="$1"
else
	echo "No project name specified"
	exit 1
fi

args=" $@ "

regexArgLicence=' -(-licence|l) ([^ ]+) '
[[ $args =~ $regexArgLicence ]]
if [ "${BASH_REMATCH[2]}" != "" ]; then
	licence="${BASH_REMATCH[2]}"
else
	licence=""
fi

# Check the licence exists
if [ ! $licence = "" ] && [ ! -f "$LICENCE_DIR/$licence" ]; then
	echo "Couldn't find the specified licence"
	exit 1
fi

regexArgGit=' -(-no-git) '
[[ $args =~ $regexArgGit ]]
if [ "${BASH_REMATCH[1]}" != "" ]; then
	git=false
else
	git=true
fi
