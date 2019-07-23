# dotfiles

## Installation

- Install required packages:

  ```sh
  pacman -Syu --needed base-devel git openssh fish neovim python-neovim
  ```

- (Optional) Install [`yay`](https://github.com/Jguer/yay):

  ```sh
  cd /tmp
  git clone https://aur.archlinux.org/yay.git
  cd yay
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
  ~/.homeshick/repos/dotfiles/setup
  ```
