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

# Get the projects name
if argExists 'name'; then
	projectName="$(argValue "name")"
else
	# Ask the user to supply the projects name
	echo -n "Enter Project Name: "
	read projectName
fi

# Determine if this is a Git tracked project
if argExists 'no-git'; then
	git=false
else
	git=true
fi

# Check a project name was provided
if [ "$projectName" == '' ]; then
	echo "No project name specified"
	exit 1
fi

# Get the projects licence
if argExists 'licence'; then
	licence="$(argValue "licence")"
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

# If a licence is being added check for a name to put on the licence
if [ "$licence" != "" ]; then

	# Check if the name for the licence has been passed as a parameter
	if argExists 'licence-name'; then
		licenceName="$(argValue "licence-name")"
	else
		# Ask for the name
		read -e -p "Enter The Name You Want To Appear On The Licence: " licenceName
	fi
fi

# Check the licence exists
if [ "$licence" != "" ] && [ ! -f "$LICENCE_DIR/$licence" ]; then
	echo "Couldn't find the specified licence"
	exit 1
fi

# Get the directory the project should be created in
if argExists 'dir'; then
	projectDir="$(argValue "dir")"
else
	projectDir="./"
fi

# Make a directory name out of the project name
projectDirName=${projectName// /-}

# Build the projects path
projectPath="$projectDir/$projectDirName"

# Check if the project already exists
if [ -d "$projectPath" ]; then
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
	git --git-dir="$projectPath/.git" init -q

	# Add the Git ignore file
	touch "$projectPath/.gitignore"

	# Make the initial commit
	git --git-dir="$projectPath/.git" --work-tree="$projectPath" add .
	git --git-dir="$projectPath/.git" --work-tree="$projectPath" commit -m "Initial Commit" -q
fi

echo "$projectName Created in $projectPath"
