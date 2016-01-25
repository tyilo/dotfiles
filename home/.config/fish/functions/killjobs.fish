function killjobs
	jobs -p | xargs -n 1 kill -9
end
