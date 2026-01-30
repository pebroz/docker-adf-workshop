#!/usr/bin/env sh
#shellcheck shell=sh

set -xe
rm -Rf ~/.wine

mkdir -p ~/.wine
chown -R $USER: ~/.wine
cd /opt/ADF-Workshop

# exec xterm
wine /opt/ADF-Workshop/ADF-Workshop.exe

# wmctrl -r :ACTIVE: -b toggle,maximized_vert,maximized_horz