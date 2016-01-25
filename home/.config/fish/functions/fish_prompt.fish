function fish_prompt
	set _status $status

	set prompt ''

	if test $_status != 0
		set prompt $prompt(set_color red)$_status(set_color normal)':'
	end

	set prompt $prompt(set_color blue)$USER(set_color normal):
	set prompt $prompt(set_color green)(prompt_pwd)


	for o in dirtystate stashstate untrackedfiles colorhints
		set -g __fish_git_prompt_show$o 1
	end

	set -g __fish_git_prompt_showupstream auto informative

	# For __fish_git_prompt
	set git_prompt (__fish_git_prompt ' (%s)')
	if test -z "$git_prompt"
		set git_prompt ''
	end

	set prompt $prompt(set_color normal)$git_prompt' '

	if set -q VIRTUAL_ENV
		set prompt $prompt(set_color 777)'['(basename "$VIRTUAL_ENV")']'(set_color normal)' '
	end

	if test "$USER" = root
		set prompt $prompt(set_color red)'#'
	else
		set prompt $prompt(set_color normal)'>'
	end

	set prompt $prompt(set_color normal)' '

	echo -n $prompt
end
