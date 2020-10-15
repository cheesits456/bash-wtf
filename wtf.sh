#!/usr/bin/env bash
VER="v1.1.0"

# errcho function for echoing to stderr
errcho() {
	>&2 echo $@
}

# Parse command-line options, set corresponding variables indicating selected options
while [[ $# -gt 0 ]]; do
	option="$1"
	case $option in
		-e|--edit)
			EDIT=1
			shift
		;;
		-h|--help)
			HELP=1
			shift
		;;
		-i|--install)
			INSTALL=1
			shift
		;;
		-r|--reset)
			RESET=1
			shift
		;;
		-u|--uninstall)
			UNINSTALL=1
			shift
		;;
		-V|--version)
			VERSION=1
			shift
		;;
		*)
			shift
		;;
	esac
done


# wtf --help
if [ "$HELP" = "1" ]; then
	echo "wtf - a command for when you have no idea wtf just happened"
	echo
	echo "Usage: wtf [options]"
	echo
	echo "Options:"
	echo "    -e, --edit           open your user-specific config in nano"
	echo "    -h, --help           display help message and exit"
	echo "    -i, --install        install the 'wtf' command globally"
	echo "    -r, --reset          reset your user-specific config to default"
	echo "    -u, --uninstall      remove the globally installed command"
	echo "    -V, --version        display version information and exit"
	echo
	echo "Config File:"
	echo "        Responses  are  read  from  '~/.config/wtf/wtf.conf'. If  that  file  is"
	echo "    missing when  the command  is run, it  will be created  and filled  with the"
	echo "    default responses. It  can then be edited to include  whatever responses you"
	echo "    want."
	echo
	echo "        Responses are saved as plaintext -  each line of the file represents one"
	echo "    possible response  to be chosen  at random.  Escape sequences like  '\n' for"
	echo "    line breaks or '\e' for color escape codes are supported."
	exit 0
fi


# wtf --install
if [ "$INSTALL" = "1" ]; then
	if [ $(whoami) != "root" ]; then
		errcho "The '--install' option can only be run by the root user"
		exit 1
	else
		if [ -x "$PWD/wtf.sh" ]; then
			cp "$PWD/wtf.sh" "/usr/local/bin/wtf"
			echo "Successfully installed!"
			echo "You can now use the command simply by typing \"wtf\""
			exit 0
		else
			errcho "A file named 'wtf.sh' must exist in your current directory in order to use the"
			errcho "'--install' option"
			exit 1
		fi
	fi
fi


# wtf --uninstall
if [ "$UNINSTALL" = "1" ]; then
	if [ $(whoami) != "root" ]; then
		errcho "The '--uninstall' option can only be run by the root user"
		exit 1
	else
		if [ -x "$(which wtf)" ]; then
			rm "$(which wtf)"
			echo "Successfully uninstalled!"
			exit 0
		else
			errcho "wtf is not installed to any directory in your current \$PATH"
			exit 1
		fi
	fi
fi


# wtf --version
if [ "$VERSION" = "1" ]; then
	echo $VER
	exit 0
fi


# wtf *

# Set default responses
read -rd '' config <<'EOF'
I don't fucking know, \e[3mLMAO
\e[35mNo fuckin' clue
\e[1;31mNo fuckin' idea
Beats me \e[36m¯\_(ツ)_/¯
That was so bad, even \e[1;3mI\e[21;23m don't know what happened
EOF

# Load config file if it exists, else write $config to a new file
if [ ! -f "$HOME/.config/wtf/wtf.conf" ] || [ "$RESET" = "1" ]; then
	mkdir -p $HOME/.config/wtf
	printf '%s\n' "$config" > $HOME/.config/wtf/wtf.conf
	# If --reset option was set, end execution here
	if [ "$RESET" = "1" ]; then
		echo "Config file reset to default!"
		exit 0
	fi
else
	config=$(cat $HOME/.config/wtf/wtf.conf)
fi

if [ "$EDIT" = "1" ]; then
	echo "Opening configuration file for editing . . ."
	nano "$HOME/.config/wtf/wtf.conf"
	echo "Done!"
	exit 0
fi

# Split config string into an array using line breaks as the delimiter
IFS=$'\n' lines=($config)
# Select a random index from the array
index=$(($RANDOM % ${#lines[@]}))
# Print the array item at the selected index, '-e' to support backslash escapes
echo -e "${lines[$index]}\e[0m"

exit 0
