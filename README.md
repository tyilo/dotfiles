dotfiles
========

Installing:

```
# Install homeshick
git clone git://github.com/andsens/homeshick.git ~/.homesick/repos/homeshick
~/.homesick/repos/homeshick/bin/homeshick clone Tyilo/dotfiles

# Install vim-plug for neovim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
nvim +PlugInstall

# Install fundle for fish
curl -fLo ~/.config/fish/functions/fundle.fish --create-dirs https://git.io/fundle
exec fish
fundle install
```

Setup keyboard:
- Install [`us_da-layout`](https://github.com/Tyilo/us_da-layout) <sup>[AUR](https://aur.archlinux.org/packages/us_da-layout/)</sup>
- Set as default: `localectl set-x11-keymap us_da '' '' 'compose:menu,caps:escape'`
