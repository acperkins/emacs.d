;; .emacs.d/init.el
;; Anthony Perkins
;; https://git.acperkins.com/acp/emacs.d

;; Set up the Emacs packaging system.
(require 'package)
(add-to-list 'package-archives '("melpa-stable" .
                                 "http://stable.melpa.org/packages/"))
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
(global-set-key (kbd "<f6>") 'whitespace-mode)

;; Automatically install required packages from the package manager.
(use-package markdown-mode
  :ensure t)
(use-package go-mode
  :ensure t)
(use-package auto-complete
  :ensure t
  :config
  (ac-config-default))
(use-package go-autocomplete
  ;; Don't forget to run `go get -u github.com/mdempsky/gocode`.
  ;; On Debian 9, use the older `go get -u github.com/nsf/gocode`.
  :ensure t)
(use-package jedi
  ;; Run (jedi:install-server) if needed
  ;; (requires `pip install --user virtualenv`).
  :ensure t
  :config
  (add-hook 'python-mode-hook 'jedi:setup)
  (setq jedi:complete-on-dot t))
(use-package powershell
  :ensure t)
(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))

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
(setq backup-by-copying t
      backup-directory-alist
      `(("." . ,user-temporary-file-directory)
        (,tramp-file-name-regexp nil))
      auto-save-list-file-prefix
      (concat user-temporary-file-directory ".auto-saves-")
      auto-save-file-name-transforms
      `((".*" ,user-temporary-file-directory t)))

;; Getting Things Done in org-mode.
;; Source: <https://emacs.cafe/emacs/orgmode/gtd/2017/06/30/orgmode-gtd.html>
(setq org-agenda-files '("~/Sync/gtd/inbox.org"
                         "~/Nextcloud/gtd/projects.org"
                         "~/Nextcloud/gtd/reminders.org")
      org-capture-templates '(("t" "Todo [inbox]" entry
                               (file+headline "~/Nextcloud/gtd/inbox.org" "Tasks")
                               "* TODO %i%?")
                              ("r" "Reminder" entry
                               (file+headline "~/Nextcloud/gtd/reminders.org"
                                              "Reminder")
                               "* %i%? \n %U"))
      org-refile-targets '(("~/Nextcloud/gtd/inbox.org" :maxlevel . 3)
                           ("~/Nextcloud/gtd/someday.org" :level . 1)
                           ("~/Nextcloud/gtd/reminders.org" :maxlevel . 2))
      org-todo-keywords '((sequence "TODO(t)"
                                    "WAITING(w)"
                                    "|"
                                    "DONE(d)"
                                    "CANCELLED(c)"))
      org-agenda-custom-commands
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
(load-theme 'tango-dark)
(put 'upcase-region 'disabled nil)
(setq auto-save-default nil
      backup-inhibited t
      c-default-style "bsd"
      calendar-week-start-day 1
      colon-double-space t
      default-frame-alist '((cursor-color . "white"))
      inhibit-startup-screen t
      line-move-visual nil
      mouse-wheel-progressive-speed nil
      mouse-wheel-scroll-amount '(1 ((shift) . 1) ((control) . nil))
      org-startup-folded nil
      org-startup-truncated nil
      org-log-done 'time
      shr-inhibit-images t
      shr-use-fonts nil
      track-eol t
      whitespace-style (quote (space-mark tab-mark newline-mark))
      x-super-keysym 'meta)
(setq-default indent-tabs-mode nil
              c-basic-offset 4)
(show-paren-mode t)
(tool-bar-mode -1)

;; Set and read the external (non checked-in) Custom file. This
;; section should always be at the end of the file.
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(if (file-readable-p (symbol-value 'custom-file))
    (load custom-file))
