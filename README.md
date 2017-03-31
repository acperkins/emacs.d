# .emacs.d

Emacs configuration repository for Anthony Perkins.

This should be cloned to `~/.emacs.d` on Linux/Unix, and to
`%APPDATA%\.emacs.d` on Windows.

## Windows taskbar

Run Emacs once on Windows and pin the icon to the taskbar. Then close
Emacs, right-click the icon, and select Properties. Remove `emacs.exe`
from the end of the command line and replace it with the following:

    emacsclientw.exe -c

This will use an existing Emacs server instance to run the client. The
file `daemon.cmd` will start an Emacs server instance.
