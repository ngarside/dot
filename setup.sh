#!/bin/bash

# Ensure the current environment is supported ------------------------------------------------------

OS=$(grep --only-matching --perl-regexp "(?<=^ID=\").*?(?=\"$)" /etc/os-release)
if [ "$OS" -ne "opensuse-tumbleweed" ]; then
	echo "This script must be run on openSUSE Tumbleweed"
	exit
fi

if [ "$EUID" -ne 0 ]; then
	echo "This script must be run as root"
	exit
fi

# Setup repositories -------------------------------------------------------------------------------

rpm --import https://packages.microsoft.com/keys/microsoft.asc

rpm --import https://download.nvidia.com/opensuse/tumbleweed/repodata/repomd.xml.key

zypper addrepo --refresh --name Azure https://packages.microsoft.com/yumrepos/azure-cli repo-azure

zypper addrepo --refresh --name Dotnet https://packages.microsoft.com/opensuse/15/prod repo-dotnet

zypper addrepo --refresh --name "VS Code" https://packages.microsoft.com/yumrepos/vscode repo-vscode

zypper addrepo --refresh --name NVIDIA https://download.nvidia.com/opensuse/tumbleweed repo-nvidia

# Install packages ---------------------------------------------------------------------------------

zypper --non-interactive install --type pattern container_runtime kde_plasma

zypper --non-interactive install --auto-agree-with-licenses \
	alsa \
	ansible \
	code \
	azure-cli \
	clamav \
	dolphin \
	dotnet-sdk-3.1 \
	dotnet-sdk-5.0 \
	dotnet-sdk-6.0 \
	flatpak \
	git \
	ImageMagick \
	kcm_sddm \
	konsole \
	latte-dock \
	npm16 \
	papirus-icon-theme \
	podman-docker \
	sddm \
	sof-firmware \
	suse-prime \
	terraform \
	x11-video-nvidiaG05

# Install flatpaks ---------------------------------------------------------------------------------

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak --noninteractive install \
	org.blender.Blender \
	org.mozilla.firefox \
	com.valvesoftware.Steam \
	com.spotify.Client \
	io.github.shiftey.Desktop \
	org.kde.kalk \
	rest.insomnia.Insomnia \
	org.kde.kclock \
	im.riot.Riot \
	org.gimp.GIMP \
	org.chromium.Chromium \
	com.microsoft.Teams \
	org.gnome.Cheese \
	io.github.sharkwouter.Minigalaxy \
	org.freedesktop.Platform.GL.nvidia-470-74 \
	org.freedesktop.Platform.GL32.nvidia-470-74

# Enable graphical boot ----------------------------------------------------------------------------

systemctl enable sddm

systemctl set-default graphical.target

# Generate SSH key ---------------------------------------------------------------------------------

sudo --login --user nathan bash << EOF
	if [ ! -f ~/.ssh/id_rsa ]; then
		ssh-keygen -t rsa -b 4096 -C code@nathangarside.com -f ~/.ssh/id_rsa -N ""
	fi
EOF

# Delete unwanted default files --------------------------------------------------------------------

sudo --login --user nathan bash << EOF
	gio trash ~/bin
	gio trash ~/Desktop/*.desktop
	gio trash ~/Public
EOF

# Install VS Code extensions -----------------------------------------------------------------------

sudo --login --user nathan bash << EOF
	code --install-extension editorconfig.editorconfig
	code --install-extension github.github-vscode-theme
	code --install-extension PKief.material-icon-theme
EOF

# Clone this repository ----------------------------------------------------------------------------

sudo --login --user nathan bash << EOF
	rm --force --recursive ~/.cache/dot
	git clone --depth 1 https://github.com/ngarside/dot ~/.cache/dot
	code --install-extension editorconfig.editorconfig
	code --install-extension github.github-vscode-theme
	code --install-extension PKief.material-icon-theme
EOF

# Copy dotfiles ------------------------------------------------------------------------------------

sudo --login --user nathan bash << EOF
	cp --recursive ~/.cache/dot/code/. ~/.config/Code/User
	cp --recursive ~/.cache/dot/git/. ~
	cp --recursive ~/.cache/dot/home/. ~
	cp --recursive ~/.cache/dot/ssh/. ~/.ssh
	cp --recursive ~/.cache/dot/vim/. ~
	cp --recursive ~/.cache/dot/wallpapers/. ~/.local/share/wallpapers
EOF
