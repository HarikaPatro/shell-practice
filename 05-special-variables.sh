#!/bin/bash

echo "script name is:$0"
echo "number of arguments is:$#"
echo "all arguments passed to the script is:$@" #all arguments as seperate word
echo "all arguments passed to the script is:$*" #all arguments as single string
echo "PID of the current shell:$$"
echo "exit status of the last command:$?"
echo "current worrking directory:$PWD"
echo "who is running this:$USER"
echo "user home directory:$HOME"
echo "PID of the last command in background:$!"