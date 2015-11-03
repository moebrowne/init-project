# Initialise New Git Project

## Usage

```bash
./init-project.sh [OPTIONS]
```

## Arguments

```bash
-q
    Quiet, no questions asked no output given, optional

--help
    Help with available commands
    
--name "[NAME]"
    The name of your project

--desc "[DESCRIPTION]"
    A one line description of your project, optional
    
--licence [LICENCE]
    Create licence (MIT, Apache2, GPL2, GPL3), default: no licence
    
--licence-name [NAME]
    The name you want to appear on the licence, if using Git it will default to your git name
  
--dir [DIRECTORY]
    Where to create your new project, default: "./"
  
--no-git
    Do not initialise as git repository, default: false
```
