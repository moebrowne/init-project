#!/bin/bash

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
