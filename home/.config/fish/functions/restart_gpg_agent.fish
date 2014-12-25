function restart_gpg_agent
	killall -INT gpg-agent
	set -e -U -x GPG_AGENT_INFO
	rm ~/.gpg-agent-info
	. ~/.config/fish/gnupg.fish
end
