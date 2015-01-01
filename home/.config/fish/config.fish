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

source ~/.aliases

switch (uname)
	case Darwin
		source ~/.aliases.osx
		source ~/.env.osx
	case Linux
		source ~/.aliases.linux
		source ~/.env.linux
end

source ~/.env

source ~/.config/fish/z.fish
source ~/.config/fish/gnupg.fish

source "$HOME/.homesick/repos/homeshick/homeshick.fish"
