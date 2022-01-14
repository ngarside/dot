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
	org.freedesktop.Platform.GL.nvidia-470-74 \
	org.freedesktop.Platform.GL32.nvidia-470-74

# Enable graphical boot ----------------------------------------------------------------------------

systemctl enable sddm

systemctl set-default graphical.target

# Generate SSH key ---------------------------------------------------------------------------------

# TODO should run as user

if [ ! -f ~/.ssh/id_rsa ]; then
	ssh-keygen -t rsa -b 4096 -C code@nathangarside.com -f ~/.ssh/id_rsa -N ""
fi

# Delete unwanted default files --------------------------------------------------------------------

# TODO should run as user

gio trash ~/bin
gio trash ~/Desktop/*.desktop
gio trash ~/Public

# Install VS Code extensions -----------------------------------------------------------------------

# TODO should run as user

code --install-extension editorconfig.editorconfig
code --install-extension github.github-vscode-theme
code --install-extension PKief.material-icon-theme
