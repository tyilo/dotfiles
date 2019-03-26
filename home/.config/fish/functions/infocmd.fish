function infocmd
	type "$argv" && \
	set path (type --path "$argv") && \
	if test -z "$path"
		exit
	else
		file "$path" && \
		begin
			pacman -Qo "$path"
			read --prompt-str 'Edit? ' ans
			if string match --quiet --ignore-case "$ans" 'y'
				$EDITOR "$path"
			end
		end
	end
end
