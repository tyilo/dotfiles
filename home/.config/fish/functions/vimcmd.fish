function vimcmd
	set cmd $argv[1]
	if type -q $cmd
		vim (type -p $cmd)
	else
		echo "The $cmd command doesn't exist."
		read -p 'echo "Create it? "' answer
		switch $answer
			case 'y*' 'Y*'
				set path ~/bin/$cmd
				touch $path
				chmod +x $path
				vim $path
		end
	end
end
