;; .emacs.d/init.el
;; Anthony Perkins
;; https://github.com/acperkins/emacs.d

;; Set up the Emacs packaging system.
(require 'package)
(add-to-list 'package-archives '("melpa"
  . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable"
  . "http://stable.melpa.org/packages/"))
(add-to-list 'package-archives '("org"
  . "http://orgmode.org/elpa/"))
(setq package-enable-at-startup nil)
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile (require 'use-package))

;; Automatically install required packages from the package manager.
(use-package helm :ensure t)
(use-package linum-relative :ensure t)
(use-package markdown-mode :ensure t)

;; Include any non checked-in packages in the ".emacs.d/site-lisp"
;; directory and checked-in packages in the ".emacs.d/lisp" directory.
(add-to-list 'load-path (expand-file-name "site-lisp" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;; Prefer UTF-8 encoding for all files.
(prefer-coding-system 'utf-8)
(setq coding-system-for-read 'utf-8)
(setq coding-system-for-write 'utf-8)

;; Load and enable heml.
(require 'helm-config)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(helm-mode t)

;; Load and enable linum-relative
(require 'linum-relative)
(linum-relative-global-mode)

;; Main options that don't come under other sections.
(c-set-offset 'arglist-cont-nonempty '4)
(global-linum-mode t)
(global-whitespace-mode t)
(load-theme 'tango-dark)
(setq auto-save-default nil)
(setq backup-inhibited t)
(setq c-default-style "bsd")
(setq inhibit-startup-screen t)
(setq initial-major-mode 'org-mode)
(setq line-move-visual nil)
(setq track-eol t)

;; Set and read the external (non checked-in) Custom file. This
;; section should always be at the end of the file.
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(if (file-readable-p (symbol-value 'custom-file))
  (load custom-file))
