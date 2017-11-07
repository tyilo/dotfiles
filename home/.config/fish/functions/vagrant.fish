function vagrant
	pushd ~/vagrant/$argv[1]
	command vagrant $argv[2..-1]
	popd
end
