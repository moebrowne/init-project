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
if [ $licence != "" ] && [ ! -f "$LICENCE_DIR/$licence" ]; then
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

regexArgDir=' --dir ([^ ]+) '
[[ $args =~ $regexArgDir ]]
if [ "${BASH_REMATCH[1]}" != "" ]; then
	projectDir="${BASH_REMATCH[1]}"
else
	projectDir="./"
fi

# Check if the project already exists
if [ -d $projectDir/$projectName ]; then
	echo "The directory $projectDir/$projectName already exists"
	exit 1
fi

# Create the project directory
mkdir -p "$projectDir/$projectName"

# Add the projects licence
if [ ! $licence = "" ]; then
	# Copy the licence to the project
	cp "$LICENCE_DIR/$licence" "$projectDir/$projectName/LICENCE"
fi

# Add the projects README
touch "$projectDir/$projectName/README.md"

# Initalise a Git repo
if [ $git = true ]; then
	# Initalise Git in the project directory
	GIT_DIR="$projectDir/$projectName/.git" git init

	# Make the inital commit
	git --git-dir="$projectDir/$projectName/.git" --work-tree="$projectDir/$projectName" add .
	git --git-dir="$projectDir/$projectName/.git" --work-tree="$projectDir/$projectName" commit -m "Inital Commit"
fi
