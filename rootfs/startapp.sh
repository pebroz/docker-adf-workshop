#!/usr/bin/env sh
#shellcheck shell=sh

set -xe
export WINEPREFIX="/config/.wine"

echo "Installing MS RichEdit Control 2.0 and Courier Fonts with Winetricks for proper ANSII text display, this may take a while..."
winetricks riched20 courier

cd /opt/ADF-Workshop

# exec xterm
wine /opt/ADF-Workshop/ADF-Workshop.exe

# wmctrl -r :ACTIVE: -b toggle,maximized_vert,maximized_horz