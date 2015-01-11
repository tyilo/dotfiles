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
		source ~/.env.osx
	;;
	Linux)
		source ~/.env.linux
	;;
esac

source ~/.env
source ~/.aliases

case $(uname) in
	Darwin)
		source ~/.aliases.osx
	;;
	Linux)
		source ~/.aliases.linux
	;;
esac

source ~/.homesick/repos/homeshick/homeshick.sh
