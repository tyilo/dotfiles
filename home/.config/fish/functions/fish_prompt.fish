function fish_prompt
	set _status $status
	
	z --add "$PWD"
	
	set prompt ''

	if test $_status != 0
		set prompt $prompt(set_color red)$_status(set_color normal)':'
	end

	set prompt $prompt(set_color blue)$USER(set_color normal):
	set prompt $prompt(set_color green)(prompt_pwd)' '
	
	if test "$USER" = root
		set prompt $prompt(set_color red)'#'
	else
		set prompt $prompt(set_color normal)'>'
	end

	set prompt $prompt' '
	echo -n $prompt
end
