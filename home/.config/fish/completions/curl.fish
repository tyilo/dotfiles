# Complete paths for @
# See https://github.com/fish-shell/fish-shell/issues/10539
complete -c curl -n 'string match -qr "@" -- (commandline -ct)' -kxa "(printf '%s\n' -- (string match -r '^.*@' -- (commandline -ct))(__fish_complete_suffix --complete=(commandline -ct | string replace -r '.*@' '') ''))"

source /usr/share/fish/vendor_completions.d/curl.fish
