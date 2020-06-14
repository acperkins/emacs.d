@ECHO OFF
REM Start Emacs in daemon mode on Windows. It assumes Emacs is
REM installed into C:\Program Files\Emacs\x86_64.
TITLE Emacs daemon
"C:\Program Files\Emacs\x86_64\bin\runemacs.exe" --daemon --chdir %USERPROFILE%
