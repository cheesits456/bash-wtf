#!/bin/bash

if [ $(whoami) != "root" ]; then
	echo "This script must be run as root"
	exit 1
fi

echo
cp ./wtf.sh /usr/local/bin/wtf
echo "Successfully installed!"
echo "You can now use the command simply by typing \"wtf\""
exit 0
