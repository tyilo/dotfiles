if status is-interactive
	starship init fish | source
	function fish_preexec --on-event fish_preexec
		tput sc
		set text "at $(set_color yellow)$(date +'%Y-%m-%d %H:%M:%S')$(set_color normal)"
		set length (string length --visible "$text")
		tput cuu 2
		tput cuf (math $COLUMNS - $length)
		echo -n "$text"
		tput rc
	end

	set -gx ATUIN_NOBIND "true"
	atuin init fish | source
	bind \cr _atuin_search
	bind -M insert \cr _atuin_search

	set -g VIRTUALFISH_PLUGINS "auto_activation compat_aliases"

	fundle plugin 'oh-my-fish/plugin-bang-bang'
	fundle plugin 'oh-my-fish/plugin-errno'
	fundle plugin 'oh-my-fish/plugin-virtualfish'
	fundle plugin 'jethrokuan/z'

	fundle init
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

source ~/.environment 2>&1 | grep -v 'set: Warning: $PATH entry'
source_aliases ~/.aliases

source "$HOME/.homesick/repos/homeshick/homeshick.fish"

set -gx MANPATH '/usr/share/man'

mise activate fish | source

if type -q opam
	eval (opam env)
	# Remove . from PATH added by the above
	if set -l i (contains -i . $PATH)
		set -e PATH[$i]
	end
end

ulimit -s unlimited
