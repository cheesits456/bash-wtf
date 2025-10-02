#!/usr/bin/env bash
VER="v1.3.1"

errcho() { >&2 echo "$@"; }

if [ -z "$HOME" ]; then
	HOME="/home/$(whoami)"
fi

while [[ $# -gt 0 ]]; do
	option="$1"
	case $option in
		-e|--edit)      EDIT=1;      shift;;
		-h|--help)      HELP=1;      shift;;
		-i|--install)   INSTALL=1;   shift;;
		-l|--list)      LIST=1;      shift;;
		-r|--reset)     RESET=1;     shift;;
		-u|--uninstall) UNINSTALL=1; shift;;
		-V|--version)   VERSION=1;   shift;;
		*) shift;;
	esac
done

if [ "$HELP" = "1" ]; then
	echo "wtf - A command for when you have no idea wtf just happened"
	echo
	echo "Usage: wtf [options]"
	echo
	echo "Options:"
	echo "    -e, --edit           Open your user-specific config in your default editor"
	echo "    -h, --help           Display help message and exit"
	echo "    -i, --install        Install the 'wtf' command globally"
	echo "    -p, --print          Print out all responses from your current config file"
	echo "    -r, --reset          Reset your user-specific config to default"
	echo "    -u, --uninstall      Remove the globally installed command"
	echo "    -V, --version        Display version information and exit"
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

if [ "$INSTALL" = "1" ]; then
	if [ "$(whoami)" != "root" ]; then
		errcho "The '--install' option can only be run by the root user"
		exit 1
	else
		if [ -x "$PWD/wtf.sh" ] && [ -r "$PWD/wtf.man" ]; then
			echo "Installing program . . ."
			cp "$PWD/wtf.sh" "/usr/local/bin/wtf"
			echo "Installing man page . . ."
			cp "$PWD/wtf.man" "/usr/share/man/man1/wtf.1"
			echo "Successfully installed!"
			echo "You can now use \"wtf\" to run the command and \"man wtf\" to view the man page"
			exit 0
		else
			errcho -e "Files 'wtf.sh'  and 'wtf.man' must exist  in your current directory  in order to\\nuse the '--install' option"
			exit 1
		fi
	fi
fi

if [ "$UNINSTALL" = "1" ]; then
	if [ "$(whoami)" != "root" ]; then
		errcho "The '--uninstall' option can only be run by the root user"
		exit 1
	else
		if [ -x "$(which wtf)" ]; then
			rm "$(which wtf)"
			rm "/usr/share/man/man1/wtf.1"
			echo "Successfully uninstalled!"
			exit 0
		else
			errcho "wtf is not installed to any directory in your current \$PATH"
			exit 1
		fi
	fi
fi

if [ "$VERSION" = "1" ]; then
	echo $VER
	exit 0
fi

read -rd '' config <<'EOF'
\e[3mLMAO\e[0m, I don't fucking know
\e[35mNo fuckin' clue\e[0m
\e[1;31mNo fuckin' idea\e[0m
Beats me \e[36m¯\_(ツ)_/¯\e[0m
That was so bad, even \e[1;3mI\e[0m don't know what happened
\e[33mTry again, you did something dumb \e[2;37m>\e[0m:\e[31m(\e[0m
Read the fucking error message \e[3mbefore\e[23m asking people for help, smh
\e[32mSomeone asked the same thing on StackOverflow \e[1m8 years ago\e[0m\n\e[33m  . . . unfortunately, they're still waiting for an answer \e[0m:\e[36m'\e[31m(\e[0m
EOF

if [ ! -f "$HOME/.config/wtf/wtf.conf" ] || [ "$RESET" = "1" ]; then
	mkdir -p "$HOME/.config/wtf"
	printf '%s\n' "$config" > "$HOME/.config/wtf/wtf.conf"
	if [ "$RESET" = "1" ]; then
		echo "Config file reset to default!"
		exit 0
	fi
else
	config=$(cat "$HOME/.config/wtf/wtf.conf")
fi

if [ "$EDIT" = "1" ]; then
	echo "Opening configuration file for editing . . ."
	"${EDITOR:-nano}" "$HOME/.config/wtf/wtf.conf"
	echo "Done!"
	exit 0
fi

if [ "$LIST" = "1" ]; then
	echo -e "$(pr -dT "$HOME/.config/wtf/wtf.conf")"
	exit 0
fi

IFS=$'\n' lines=($config)
index=$(($RANDOM % ${#lines[@]}))

if test -t 1 && test -n "$(tput colors)" && test "$(tput colors)" -ge 8; then
 	echo -e "${lines[$index]}\e[0m"
else
 	echo -e "${lines[$index]}" | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g"
fi

exit 0
