FROM archlinux:base

# Install dependencies
RUN pacman -Syu --needed --noconfirm base-devel git openssh fish neovim python-neovim starship

# Install us_da-layout
RUN useradd builduser
RUN echo 'Defaults lecture = never' >> /etc/sudoers
RUN echo 'builduser ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
RUN sudo -u builduser bash -c 'cd /tmp && \
	git clone https://aur.archlinux.org/us_da-layout.git && \
	cd us_da-layout && \
	makepkg --install --syncdeps --noconfirm'

# Install homeshick and clone dotfiles
RUN git clone git://github.com/andsens/homeshick.git ~/.homesick/repos/homeshick
RUN yes | ~/.homesick/repos/homeshick/bin/homeshick clone Tyilo/dotfiles

# Run setup script
RUN ~/.homesick/repos/dotfiles/setup

# Test if fish config works
RUN fish ~/.config/fish/config.fish

CMD ["fish"]
