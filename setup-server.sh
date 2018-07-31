#!/bin/sh

APPLICATION_DIR=~/.local/share/applications
SYSTEMD_SERVICE_DIR=~/.config/systemd/user

mkdir -p $APPLICATION_DIR
cp emacs.desktop $APPLICATION_DIR/emacs.desktop
mkdir -p $SYSTEMD_SERVICE_DIR
cp emacs.service $SYSTEMD_SERVICE_DIR/emacs.service

systemctl --user daemon-reload && \
    systemctl --user start emacs.service && \
    systemctl --user enable emacs.service
