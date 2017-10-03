function setenv
	switch $argv[1]
		case PATH MANPATH INFOPATH
			# Replace colons and spaces with newlines
			set -gx $argv[1] (echo $argv[2] | /usr/bin/tr ': ' \n)
 		case '*'
			set -gx $argv
	end
end

function source_aliases
	# sed 's/alias \([^=]*\)=/abbr -a \1 /g' $argv[1] | source
	source < $argv[1]
end

# Fix syncing of history
function save_history --on-event fish_preexec
    history --save
end

## Remove duplicated
# set -x PATH (echo $PATH | tr ' ' '\n' | nl | sort -u -k2 | sort -n | cut -f2-)

set fish_greeting ''

stty werase undef
bind \cw backward-kill-word

switch (uname)
	case Darwin
		switch (uname -m)
			case 'iPhone*'
				set _osname 'ios'
			case '*'
				set _osname 'osx'
		end
	case Linux
		set _osname 'linux'
end

if [ -n "$_osname" ]
	source ~/.env."$_osname"
end

source ~/.env
source_aliases ~/.aliases


if [ -n "$_osname" ]
	source_aliases ~/.aliases."$_osname"
end

source "$HOME/.homesick/repos/homeshick/homeshick.fish"

complete --command hub --wraps git

eval (python -m virtualfish auto_activation)

# OPAM configuration
# . /home/tyilo/.opam/opam-init/init.fish > /dev/null 2> /dev/null or true
