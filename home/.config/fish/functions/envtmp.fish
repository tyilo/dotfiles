function envtmp
	set env $argv[1]
	set args (echo $env | tr '=' '\n')
	set name $args[1]
	set -x $name $args[2..-1]
	
	eval $argv[2..-1]

	set -e $name
end
