if command -s vagrant
	function vagrant
		set box $argv[1]
		set args $argv[2..-1]
		set dir ~/vagrant/$box

		if not test -d $dir
			echo "$dir does not exist."
			echo "Available boxes:" (fish -c 'cd ~/vagrant; echo *')
			read --prompt-str "Create $box? [yN] " reply
			if test (string lower $reply) != "y"
				return
			end
			mkdir $dir
		end

		if test "$args[1]" = "down"
			set args[1] halt
		end

		pushd $dir
		command vagrant $args
		popd
	end
end
