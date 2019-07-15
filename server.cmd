@ECHO OFF
REM Start Emacs in daemon mode on Windows. It assumes Emacs is
REM installed into %LOCALAPPDATA%\Emacs.
TITLE Emacs daemon
"%LOCALAPPDATA%\Emacs\bin\runemacs.exe" --daemon --chdir %USERPROFILE%
