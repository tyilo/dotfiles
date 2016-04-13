function proxyon
	set -x -g HTTP_PROXY http://127.0.0.1:8888/
	set -x -g http_proxy "$HTTP_PROXY"
	set -x -g HTTPS_PROXY http://127.0.0.1:8888/
end
