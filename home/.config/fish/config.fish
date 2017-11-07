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
homeshick --quiet refresh

complete --command hub --wraps git

# bobthefish config
# https://github.com/oh-my-fish/theme-bobthefish
set -g theme_display_vagrant yes
set -g theme_display_date no
set -g theme_show_exit_status yes
set -g theme_nerd_fonts yes
