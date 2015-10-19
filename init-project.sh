#!/bin/bash

# Get the source directory
SOURCE_ROOT="${BASH_SOURCE%/*}"

# Set the library root path
LIBRARY_PATH_ROOT="$SOURCE_ROOT/libs"

# Include all libraries in the libs directory
for f in "$LIBRARY_PATH_ROOT"/*.sh; do
	# Include the directory
	source "$f"
done

# Set the directory the licences can be found in
LICENCE_DIR="$SOURCE_ROOT/licences"

# Build an array of licence names
LICENCE_ARRAY=("$LICENCE_DIR"/*)
LICENCE_ARRAY=("${LICENCE_ARRAY[@]##*/}")

# Add a no licence option
LICENCE_ARRAY=(${LICENCE_ARRAY[@]} 'None')

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
	# Ask the user to enter which licence they want to use
	echo "Which licence do you want to release your project under?";
	select licence in ${LICENCE_ARRAY[@]}; do
		if [[ "$licence" = '' ]]; then
			echo 'Invalid Option';
		else
			if [[ "$licence" = 'None' ]]; then
				licence=''
			fi
			break;
		fi
	done
fi

# Check the licence exists
if [ "$licence" != "" ] && [ ! -f "$LICENCE_DIR/$licence" ]; then
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

# Build the projects path
projectPath="$projectDir/$projectName"

# Check if the project already exists
if [ -d $projectPath ]; then
	echo "The directory $projectPath already exists"
	exit 1
fi

# Create the project directory
mkdir -p "$projectPath"

# Add the projects licence
if [ ! $licence = "" ]; then
	# Copy the licence to the project
	cp "$LICENCE_DIR/$licence" "$projectPath/LICENCE"
fi

# Add the projects README
touch "$projectPath/README.md"

# Initialise a Git repo
if [ $git = true ]; then
	# Initialise Git in the project directory
	git --git-dir="$projectPath/.git" init

	# Add the Git ignore file
	touch "$projectPath/.gitignore"

	# Make the initial commit
	git --git-dir="$projectPath/.git" --work-tree="$projectPath" add .
	git --git-dir="$projectPath/.git" --work-tree="$projectPath" commit -m "Initial Commit"
fi
