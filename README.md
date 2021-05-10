# dotfiles

## Installation

- Install required packages:

  ```sh
  pacman -Syu --needed base-devel git openssh fish neovim python-neovim
  ```

- (Optional) Install [`paru`](https://github.com/Morganamilo/paru):

  ```sh
  cd /tmp
  git clone https://aur.archlinux.org/paru.git
  cd paru
  makepkg -si
  ```

- Install [`us_da-layout`](https://github.com/Tyilo/us_da-layout) <sup>[AUR](https://aur.archlinux.org/packages/us_da-layout/)</sup>

- Install [`homeshick`](https://github.com/andsens/homeshick) and clone this repo with it:

  ```sh
  git clone git://github.com/andsens/homeshick.git ~/.homesick/repos/homeshick
  ~/.homesick/repos/homeshick/bin/homeshick clone Tyilo/dotfiles
  ```

- Run [setup script](setup):

  ```sh
  ~/.homesick/repos/dotfiles/setup
  ```

## Setting up formatters / linters for ale

```sh
pip install --user -r ~/.local/requirements.txt
```

```sh
npm config set prefix ~/.local
npm install --global prettier svelte prettier-plugin-svelte htmlhint
```
