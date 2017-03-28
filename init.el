(require 'package)
(add-to-list 'package-archives '("org"
  . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa"
  . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable"
  . "http://stable.melpa.org/packages/"))
(setq package-enable-at-startup nil)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
 (require 'use-package))

(use-package markdown-mode
  :ensure t)
(use-package helm
  :ensure t)

(setq c-default-style "bsd")
(c-set-offset 'arglist-cont-nonempty '4)
(setq inhibit-startup-screen t)
(setq backup-inhibited t)
(setq auto-save-default nil)
(setq initial-major-mode 'org-mode)
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(load-theme 'tango-dark)

(prefer-coding-system 'utf-8)
(setq coding-system-for-read 'utf-8)
(setq coding-system-for-write 'utf-8)

(global-linum-mode t)
(global-visual-line-mode t)
