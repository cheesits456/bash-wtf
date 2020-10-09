#!/bin/bash
VERSION="v1.0.0"

if [ ! -z "$1" ]; then
	if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
		echo "wtf - A command for when you have no idea wtf just happened"
		echo
		echo "Usage: wtf [options]"
		echo
		echo "Options:"
		echo "    -h, --help           display help message and exit"
		echo "    -V, --version        display version information and exit"
		exit 0
	elif [ "$1" = "-V" ] || [ "$1" = "--version" ]; then
		echo $VERSION
		exit 0
	fi
fi

lines[0]="I don't fucking know, LMAO"
lines[1]="No fuckin' clue"
lines[2]="No fuckin' idea"
lines[3]="Beats me ¯\_(ツ)_/¯"
lines[4]="That was so bad, even I don't know what happened"

size=${#lines[@]}
index=$(($RANDOM % $size))

echo ${lines[$index]}

exit 0
