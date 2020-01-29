fundle plugin 'oh-my-fish/plugin-bang-bang'
fundle plugin 'oh-my-fish/theme-bobthefish'
fundle plugin 'oh-my-fish/plugin-errno'
fundle plugin 'jethrokuan/z'

fundle init

function setenv
	switch $argv[1]
		case PATH MANPATH INFOPATH
			set -l paths
			# Replace colons and spaces with newlines
			for path in (echo $argv[2] | /usr/bin/tr ': ' \n)
				if [ -d "$path" ]
					set paths $paths "$path"
				end
			end
			set -gx $argv[1] $paths
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

# bobthefish config
# https://github.com/oh-my-fish/theme-bobthefish
set -g theme_display_vagrant yes
set -g theme_display_date no
set -g theme_show_exit_status yes
set -g theme_nerd_fonts yes

set -gx MANPATH '/usr/share/man'

if type -q opam
	eval (opam env)
	# Remove . from PATH added by the above
	if set -l i (contains -i . $PATH)
		set -e PATH[$i]
	end
end
