set -l PY_FRAMEWORK /opt/local/Library/Frameworks/Python.framework/Versions
set -x GOPATH ~/go

set -l orig_PATH $PATH

set -x PATH ~/bin
set -x PATH $PATH /usr/local/opt/ruby/bin
set -x PATH $PATH /opt/theos/bin
set -x PATH $PATH $GOPATH/bin
set -x PATH $PATH ~/.cabal/bin
set -x PATH $PATH /usr/local/bin /usr/local/sbin
set -x PATH $PATH /opt/local/bin /opt/local/sbin
#set -x PATH $PATH $PY_FRAMEWORK/2.7/bin $PY_FRAMEWORK/3.3/bin
set -x PATH $PATH $orig_PATH

# Remove duplicated
set -x PATH (echo $PATH | tr ' ' '\n' | nl | sort -u -k2 | sort -n | cut -f2-)

set -x EDITOR vim

set -x GREP_OPTIONS --color=auto

set -x THEOS /opt/theos
set -x THEOS_DEVICE_IP iphone
set -x THEOS_DEVICE_PORT 2222

set -x iOSOpenDevPath /opt/iOSOpenDev
set -x iOSOpenDevDevice iphone

set -x LC_ALL en_US.UTF-8
set -x LANG $LC_ALL

set fish_greeting ''

set SIMBLpatches "$HOME/Library/Application Support/SIMBL/Plugins/SIMBLpatches.bundle/Contents/MacOS/SIMBLpatches"

set -x IJVM_SPEC_FILE "$HOME/bin/ijvm.spec"

stty werase undef
bind \cw backward-kill-word

. ~/.aliases

. ~/.config/fish/z.fish
. ~/.config/fish/gnupg.fish

source "$HOME/.homesick/repos/homeshick/homeshick.fish"
