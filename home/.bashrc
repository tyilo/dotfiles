function setenv() {
	export "$1=$2"
}

export PROMPT_COMMAND=__prompt_command

function __prompt_command() {
	_status=$?

	reset="\[$(tput sgr0)\]"
	red="\[$(tput setaf 1)\]"
	green="\[$(tput setaf 2)\]"
	blue="\[$(tput setaf 4)\]"

	PS1=""

	if [[ $_status != 0 ]]; then
		PS1="$PS1$red$_status$reset:"
	fi

	PS1="$PS1$blue\u$reset:"
	PS1="$PS1$green\w$reset "

	if [[ $USER == root ]]; then
		PS1="$PS1$red#$reset"
	else
		PS1="$PS1$"
	fi

	PS1="$PS1 "
	export PS1
}

case $(uname) in
	Darwin)
		case $(uname -m) in
			iPhone*)
				_osname='ios'
			;;
			*)
				_osname='osx'
			;;
		esac
	;;
	Linux)
		_osname='linux'
	;;
esac

if [[ -n $_osname ]]; then
	source ~/.env."$_osname"
fi

source ~/.env
source ~/.aliases

if [[ -n $_osname ]]; then
	source ~/.aliases."$_osname"
fi

source ~/.homesick/repos/homeshick/homeshick.sh
