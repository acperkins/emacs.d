#!/bin/sh

APPLICATION_DIR=~/.local/share/applications
AUTOSTART_DIR=~/.config/systemd/user

mkdir -p $APPLICATION_DIR
cp emacs.desktop $APPLICATION_DIR/emacs.desktop
mkdir -p $AUTOSTART_DIR
cp emacs-server.desktop $AUTOSTART_DIR/emacs.service
emacs --daemon
