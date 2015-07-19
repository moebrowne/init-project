#!/bin/bash

if [[ ! $1 = "" ]]; then
	projectName="$1"
else
	echo "No project name specified"
	exit 1
fi
