function gitjk
	history | sed 's/hub/git/' | head -10 | gitjk_cmd $argv;
end
