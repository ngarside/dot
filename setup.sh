#!/bin/bash

# --------------------------------------------------------------------------------------------------

if [ "$EUID" -ne 0 ]
	then echo "This script must be run as root"
	exit
fi

# --------------------------------------------------------------------------------------------------

rpm --import https://packages.microsoft.com/keys/microsoft.asc

rpm --import https://download.nvidia.com/opensuse/tumbleweed/repodata/repomd.xml.key

zypper addrepo --refresh --name Azure https://packages.microsoft.com/yumrepos/azure-cli repo-azure

zypper addrepo --refresh --name Dotnet https://packages.microsoft.com/opensuse/15/prod repo-dotnet

zypper addrepo --refresh --name "VS Code" https://packages.microsoft.com/yumrepos/vscode repo-vscode

zypper addrepo --refresh --name NVIDIA https://download.nvidia.com/opensuse/tumbleweed repo-nvidia

# --------------------------------------------------------------------------------------------------

zypper install --type pattern container_runtime kde_plasma

zypper install code \
	azure-cli \
	dolphin \
	dotnet-sdk-3.1 \
	dotnet-sdk-5.0 \
	dotnet-sdk-6.0 \
	flatpak \
	konsole \
	npm16 \
	papirus-icon-theme \
	podman-docker \
	sddm

# --------------------------------------------------------------------------------------------------

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# --------------------------------------------------------------------------------------------------

flatpak --noninteractive install \
	org.mozilla.firefox \
	com.valvesoftware.Steam \
	com.spotify.Client \
	io.github.shiftey.Desktop \
	org.kde.kalk \
	rest.insomnia.Insomnia \
	org.kde.kclock

# --------------------------------------------------------------------------------------------------

systemctl enable sddm

systemctl set-default graphical.target

# --------------------------------------------------------------------------------------------------

gio trash ~/bin

gio trash ~/Public
