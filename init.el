;; .emacs.d/init.el
;; Anthony Perkins
;; https://code.acperkins.com/acp/emacs.d

;; Initialise packages.
(package-initialize)
(add-to-list 'package-archives '("melpa-stable" .
                                 "https://stable.melpa.org/packages/")
             t)
(require 'company)
(require 'company-lsp)
(require 'lsp)
(require 'lsp-clients)
(add-hook 'c-mode-hook 'lsp)
(push 'company-lsp company-backends)
(add-hook 'after-init-hook 'global-company-mode)
(autoload 'adoc-mode "adoc-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.adoc\\'" . adoc-mode))
(autoload 'yaml-mode "yaml-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))

;; Include any non checked-in packages in the ".emacs.d/site-lisp"
;; directory and checked-in packages in the ".emacs.d/lisp" directory.
(add-to-list 'load-path (expand-file-name "site-lisp" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;; Reduce cramp from common keyboard shortcuts.
(define-key key-translation-map (kbd "<f9>") (kbd "M-x"))

;; Prefer UTF-8 encoding for all files.
(prefer-coding-system 'utf-8)

;; Show ISO week numbers in calendar.
;; Source: <https://www.emacswiki.org/emacs/CalendarWeekNumbers>
(copy-face font-lock-constant-face 'calendar-iso-week-face)
(set-face-attribute 'calendar-iso-week-face nil :height 0.7)
(setq calendar-intermonth-text
      '(propertize
        (format "%2d"
                (car
                 (calendar-iso-from-absolute
                  (calendar-absolute-from-gregorian (list month day year)))))
        'font-lock-face 'font-lock-function-name-face))

;; Use a theme.
;(load-theme 'tango-dark)
;(setq default-frame-alist '((cursor-color . "white")))
(load-theme 'modus-operandi t)

;; Main options that don't come under other sections.
(c-set-offset 'arglist-cont-nonempty '4)
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(setq auto-save-default nil
      backup-inhibited t
      c-default-style "bsd"
      calendar-week-start-day 1
      colon-double-space nil
      column-number-mode t
      inhibit-startup-screen t
      line-move-visual nil
      mouse-wheel-progressive-speed nil
      mouse-wheel-scroll-amount '(4 ((shift) . 1) ((control) . 8))
      org-startup-folded nil
      org-startup-truncated nil
      org-log-done 'time
      sentence-end-double-space nil
      shr-inhibit-images t
      shr-use-fonts nil
      track-eol t
      visible-bell t
      whitespace-line-column 78
      whitespace-style '(face lines-tail trailing tabs tab-mark)
      x-super-keysym 'meta)
(setq-default indent-tabs-mode t
              c-basic-offset 8
              fill-column 78
              frame-title-format '("%b"))
(show-paren-mode t)
(global-whitespace-mode 1)
(electric-pair-mode 1)

;; Set up Magit.
(global-set-key (kbd "C-x g") 'magit-status)

;; Set and read the external (non checked-in) Custom file. This
;; section should always be at the end of the file.
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(if (file-readable-p (symbol-value 'custom-file))
    (load custom-file))
