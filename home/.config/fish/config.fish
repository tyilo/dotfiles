function setenv
	switch $argv[1]
		case PATH MANPATH INFOPATH
			# Replace colons and spaces with newlines
			set -gx $argv[1] (echo $argv[2] | /usr/bin/tr ': ' \n)
 		case '*'
			set -gx $argv
	end
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
source ~/.aliases


if [ -n "$_osname" ]
	source ~/.aliases."$_osname"
end

source "$HOME/.homesick/repos/homeshick/homeshick.fish"
