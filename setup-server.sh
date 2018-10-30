#!/bin/sh

APPLICATION_DIR=~/.local/share/applications
AUTOSTART_DIR=~/.config/autostart

mkdir -p $APPLICATION_DIR
cp emacs-client.desktop $APPLICATION_DIR/emacs-client.desktop
mkdir -p $AUTOSTART_DIR
cp emacs-server.desktop $AUTOSTART_DIR/emacs-server.desktop
