;; .emacs.d/init.el
;; Anthony Perkins
;; https://acperkins.com/r/acp/emacs.d

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
(define-key key-translation-map (kbd "<f5>") (kbd "C-u"))
(define-key key-translation-map (kbd "<f7>") (kbd "C-c"))
(define-key key-translation-map (kbd "<f8>") (kbd "C-x"))
(define-key key-translation-map (kbd "<f9>") (kbd "M-x"))

;; Automatically install required packages from the package manager.
(unless (version< emacs-version "25.0")
  (use-package helm
    :ensure t
    :init
    (global-set-key (kbd "M-x") 'helm-M-x)
    (global-set-key (kbd "C-x C-f") 'helm-find-files)
    :config
    (require 'helm-config)
    (helm-mode t)))
(use-package markdown-mode
  :ensure t)
(use-package org
  :ensure t
  :config
  (require 'org))
(use-package go-mode
  :ensure t)
(use-package auto-complete
  :ensure t
  :config
  (ac-config-default))
(use-package go-autocomplete
  ; Don't forget to run `go get -u github.com/nsf/gocode`.
  :ensure t)

;; Include any non checked-in packages in the ".emacs.d/site-lisp"
;; directory and checked-in packages in the ".emacs.d/lisp" directory.
(add-to-list 'load-path (expand-file-name "site-lisp" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;; Prefer UTF-8 encoding for all files.
(prefer-coding-system 'utf-8)

;; Define function to shutdown emacs server instance.
;; Source: <https://www.emacswiki.org/emacs/EmacsAsDaemon>
(defun server-shutdown ()
  "Save buffers, Quit, and Shutdown (kill) server"
  (interactive)
  (save-some-buffers)
  (kill-emacs))

;; Run the whole buffer through an external command.
;; Source: <https://www.emacswiki.org/emacs/ExecuteExternalCommand>
(defun shell-command-on-buffer ()
  "Asks for a command and executes it in inferior shell with current buffer
as input."
  (interactive)
  (shell-command-on-region
   (point-min) (point-max)
   (read-shell-command "Shell command on buffer: ")
   nil t))
(global-set-key (kbd "M-\"") 'shell-command-on-buffer)

;; Show ISO week numbers in calendar.
;; Source: <https://www.emacswiki.org/emacs/CalendarWeekNumbers>
(copy-face font-lock-constant-face 'calendar-iso-week-face)
(set-face-attribute 'calendar-iso-week-face nil
                    :height 0.7)
(setq calendar-intermonth-text
      '(propertize
        (format "%2d"
                (car
                 (calendar-iso-from-absolute
                  (calendar-absolute-from-gregorian (list month day year)))))
        'font-lock-face 'font-lock-function-name-face))

;; Save temporary files in the temporary directory.
;; Source: <https://stackoverflow.com/a/33085>
(defvar user-temporary-file-directory
  (concat temporary-file-directory user-login-name "/"))
(make-directory user-temporary-file-directory t)
(setq backup-by-copying t)
(setq backup-directory-alist
      `(("." . ,user-temporary-file-directory)
        (,tramp-file-name-regexp nil)))
(setq auto-save-list-file-prefix
      (concat user-temporary-file-directory ".auto-saves-"))
(setq auto-save-file-name-transforms
      `((".*" ,user-temporary-file-directory t)))

;; Getting Things Done in org-mode.
;; Source: <https://emacs.cafe/emacs/orgmode/gtd/2017/06/30/orgmode-gtd.html>
(setq org-agenda-files '("~/Sync/gtd/inbox.org"
                         "~/Sync/gtd/projects.org"
                         "~/Sync/gtd/reminders.org"))
(setq org-capture-templates '(("t" "Todo [inbox]" entry
                               (file+headline "~/Sync/gtd/inbox.org" "Tasks")
                               "* TODO %i%?")
                              ("r" "Reminder" entry
                               (file+headline "~/Sync/gtd/reminders.org"
                                              "Reminder")
                               "* %i%? \n %U")))
(setq org-refile-targets '(("~/Sync/gtd/inbox.org" :maxlevel . 3)
                           ("~/Sync/gtd/someday.org" :level . 1)
                           ("~/Sync/gtd/reminders.org" :maxlevel . 2)))
(setq org-todo-keywords '((sequence "TODO(t)"
                                    "WAITING(w)"
                                    "|"
                                    "DONE(d)"
                                    "CANCELLED(c)")))
(setq org-agenda-custom-commands
      '(("w" "Work" tags-todo "@work"
         ((org-agenda-overriding-header "Work")
          (org-agenda-skip-function
          #'my-org-agenda-skip-all-siblings-but-first)))))
(defun my-org-agenda-skip-all-siblings-but-first ()
  "Skip all but the first non-done entry."
  (let (should-skip-entry)
    (unless (org-current-is-todo)
      (setq should-skip-entry t))
    (save-excursion
      (while (and (not should-skip-entry) (org-goto-sibling t))
        (when (org-current-is-todo)
          (setq should-skip-entry t))))
    (when should-skip-entry
      (or (outline-next-heading)
          (goto-char (point-max))))))
(defun org-current-is-todo ()
  (string= "TODO" (org-get-todo-state)))

;; Main options that don't come under other sections.
(c-set-offset 'arglist-cont-nonempty '4)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cc" 'org-capture)
(define-key global-map "\C-ck" 'kill-this-buffer)
(global-whitespace-mode)
(load-theme 'tango-dark)
(setq auto-save-default nil)
(setq backup-inhibited t)
(setq c-default-style "bsd")
(setq calendar-week-start-day 1)
(setq inhibit-startup-screen t)
(setq line-move-visual nil)
(setq org-startup-folded nil)
(setq org-log-done 'time)
(setq shr-inhibit-images t)
(setq shr-use-fonts nil)
(setq track-eol t)
(setq whitespace-style (delete 'empty whitespace-style))
(setq whitespace-style (delete 'lines whitespace-style))
(setq x-super-keysym 'meta)
(setq-default indent-tabs-mode nil)
(show-paren-mode t)

;; Set and read the external (non checked-in) Custom file. This
;; section should always be at the end of the file.
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(if (file-readable-p (symbol-value 'custom-file))
  (load custom-file))
