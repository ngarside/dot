#!/bin/bash

# Ensure the current environment is supported ------------------------------------------------------

OS=$(grep --only-matching --perl-regexp "(?<=^ID=\").*?(?=\"$)" /etc/os-release)
if [ "$OS" -ne "fedora" ]; then
	echo "This script must be run on openSUSE Tumbleweed"
	exit
fi

if [ "$EUID" -ne 0 ]; then
	echo "This script must be run as root"
	exit
fi

# Enable graphical boot ----------------------------------------------------------------------------

systemctl set-default graphical.target

# Install packages ---------------------------------------------------------------------------------

dnf install --assumeyes \
	flatpak \
	gnome-shell \
	gnome-terminal \
	nautilus \
	papirus-icon-theme \
	podman \
	podman-docker \

# Install flatpaks ---------------------------------------------------------------------------------

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak remote-delete fedora

flatpak --noninteractive install \
	org.blender.Blender \
	org.mozilla.firefox \
	com.valvesoftware.Steam \
	com.spotify.Client \
	io.github.shiftey.Desktop \
	org.gnome.Calculator \
	rest.insomnia.Insomnia \
	org.gnome.clocks \
	im.riot.Riot \
	org.gimp.GIMP \
	org.chromium.Chromium \
	org.gnome.Cheese \
