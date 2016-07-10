# Initialise A New Project

A little script that sets up a new project with all the essentials.

## What Are The Essentials?

* Basic `README.md`
* Licence of your choice
* Git repo. Inc `.gitignore` and initial commit


## Usage

```bash
./init-project.sh [OPTIONS]
```

## Arguments

```bash
--name
	The name of the project

--licence
	Create licence (MIT, Apache2, GPL2, GPL3)  (default: 'None')

--licence-name
	Name that will appear on the licence, if using one. Will default to your Git user.name (unless --no-git is passed)

--no-git
	Do not initialise as git repository  (default: 'false')

--desc
	A one line description of your project (optional) 

--dir
	Where to create your new project  (default: '.')

-q
	Quiet, no questions asked no output given (optional)  (default: 'false')

-h --help
	This help message
```
