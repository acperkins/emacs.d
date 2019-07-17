#!/bin/sh

EMACS_VERSION=$(emacs --version | head -n1 | awk '{print $3}')
APPLICATION_DIR=~/.local/share/applications
AUTOSTART_DIR=~/.config/autostart
SYSTEMD_DIR=~/.config/systemd/user
EMACS_DIR=/usr/share/emacs/$EMACS_VERSION

mkdir -p $APPLICATION_DIR
cp emacs-client.desktop $APPLICATION_DIR/emacs-client.desktop

if [ -r $EMACS_DIR/etc/emacs.service ]; then
    mkdir -p $SYSTEMD_DIR
    cp $EMACS_DIR/etc/emacs.service $SYSTEMD_DIR/emacs.service
    systemctl enable --user --now emacs.service
else
    mkdir -p $AUTOSTART_DIR
    cp emacs-server.desktop $AUTOSTART_DIR/emacs-server.desktop
fi
