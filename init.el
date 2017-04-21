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

;; Reduce cramp from common keyboard shortcuts.
(define-key key-translation-map (kbd "<f7>") (kbd "C-c"))
(define-key key-translation-map (kbd "<f8>") (kbd "C-x"))
(define-key key-translation-map (kbd "<f9>") (kbd "M-x"))

;; Automatically install required packages from the package manager.
(use-package helm
  :ensure t
  :init
  (global-set-key (kbd "M-x") 'helm-M-x)
  (global-set-key (kbd "C-x C-f") 'helm-find-files)
  :config
  (require 'helm-config)
  (helm-mode t))
(use-package linum-relative
  :ensure t
  :config
  (require 'linum-relative)
  (linum-relative-global-mode))
(use-package markdown-mode
  :ensure t)
(use-package org
  :ensure t
  :config
  (require 'org))
(use-package evil
  :ensure t
  :config
  (require 'evil)
  (evil-mode 1))
(use-package evil-org
  :ensure t
  :config
  (require 'evil-org))

;; Include any non checked-in packages in the ".emacs.d/site-lisp"
;; directory and checked-in packages in the ".emacs.d/lisp" directory.
(add-to-list 'load-path (expand-file-name "site-lisp" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;; Prefer UTF-8 encoding for all files.
(prefer-coding-system 'utf-8)
(setq coding-system-for-read 'utf-8)
(setq coding-system-for-write 'utf-8)

;; Define function to shutdown emacs server instance.
;; Source: <https://www.emacswiki.org/emacs/EmacsAsDaemon#toc12>
(defun server-shutdown ()
  "Save buffers, Quit, and Shutdown (kill) server"
  (interactive)
  (save-some-buffers)
  (kill-emacs))

;; Show ISO week numbers in calendar.
(setq calendar-intermonth-text
      '(propertize
        (format "%2d"
                (car
                 (calendar-iso-from-absolute
                  (calendar-absolute-from-gregorian (list month day year)))))
        'font-lock-face 'font-lock-function-name-face))

;; Main options that don't come under other sections.
(c-set-offset 'arglist-cont-nonempty '4)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cc" 'org-capture)
(global-linum-mode t)
(global-whitespace-mode t)
(load-theme 'tango-dark)
(setq auto-save-default nil)
(setq backup-inhibited t)
(setq c-default-style "bsd")
(setq calendar-week-start-day 1)
(setq inhibit-startup-screen t)
(setq initial-major-mode 'org-mode)
(setq line-move-visual nil)
(setq org-startup-folded nil)
(setq org-log-done 'time)
(setq shr-inhibit-images t)
(setq shr-use-fonts nil)
(setq track-eol t)
(setq-default indent-tabs-mode nil)
(show-paren-mode t)

;; Set and read the external (non checked-in) Custom file. This
;; section should always be at the end of the file.
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(if (file-readable-p (symbol-value 'custom-file))
  (load custom-file))
