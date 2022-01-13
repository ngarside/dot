#!/bin/bash

# --------------------------------------------------------------------------------------------------

if [ "$EUID" -ne 0 ]
	then echo "This script must be run as root"
	exit
fi

# --------------------------------------------------------------------------------------------------

zypper install --type pattern container_runtime kde_plasma

zypper install flatpak konsole npm16 sddm

# --------------------------------------------------------------------------------------------------

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# --------------------------------------------------------------------------------------------------

flatpak --noninteractive install \
	org.mozilla.firefox \
	com.valvesoftware.Steam \
	com.spotify.Client \
	io.github.shiftey.Desktop \
	org.kde.kcalc \
	rest.insomnia.Insomnia \
	org.kde.kclock

# --------------------------------------------------------------------------------------------------

systemctl enable sddm

systemctl set-default graphical.target

# --------------------------------------------------------------------------------------------------

gio trash ~/bin

gio trash ~/Public
