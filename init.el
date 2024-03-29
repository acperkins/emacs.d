;; .emacs.d/init.el
;; Anthony Perkins
;; https://code.acperkins.com/acp/emacs.d

;; Initialise packages.
(package-initialize)
(add-to-list 'package-archives '("melpa-stable" .
                                 "https://stable.melpa.org/packages/")
             t)

;; Include any non checked-in packages in the ".emacs.d/site-lisp"
;; directory and checked-in packages in the ".emacs.d/lisp" directory.
(add-to-list 'load-path (expand-file-name "site-lisp" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(mouse-wheel-mode 't)
(autoload 'adoc-mode "adoc-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.adoc\\'" . adoc-mode))
(autoload 'yaml-mode "yaml-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))

;; Reduce cramp from common keyboard shortcuts.
(global-set-key (kbd "<f7>") 'ispell-buffer)
(define-key key-translation-map (kbd "<f9>") (kbd "M-x"))
(global-set-key (kbd "<f12>") 'save-buffer)
(global-set-key (kbd "<M-f11>") 'olivetti-mode)

;; Assign left-hand keys on a Sun keyboard.
(global-set-key (kbd "<cancel>"   ) 'keyboard-quit)           ; Stop
(global-set-key (kbd "<redo>"     ) 'repeat-complex-command)  ; Again
(global-set-key (kbd "<SunProps>" ) 'describe-function)       ; Props
(global-set-key (kbd "<undo>"     ) 'undo)                    ; Undo
(global-set-key (kbd "<SunFront>" ) 'delete-other-windows)    ; Front
(global-set-key (kbd "<XF86Copy>" ) 'kill-ring-save)          ; Copy
(global-set-key (kbd "<XF86Open>" ) 'find-file)               ; Open
(global-set-key (kbd "<XF86Paste>") 'yank)                    ; Paste
(global-set-key (kbd "<find>"     ) 'isearch-forward)         ; Find
(global-set-key (kbd "<XF86Cut>"  ) 'kill-region)             ; Cut

;; Prefer UTF-8 encoding for all files.
(prefer-coding-system 'utf-8)

;; Show ISO week numbers in calendar.
;; Source: <https://www.emacswiki.org/emacs/CalendarWeekNumbers>
(copy-face font-lock-constant-face 'calendar-iso-week-face)
(set-face-attribute 'calendar-iso-week-face nil :height 0.7)
(setq calendar-intermonth-text '(propertize
        (format "%2d"
                (car
                 (calendar-iso-from-absolute
                  (calendar-absolute-from-gregorian (list month day year))))) 'font-lock-face
        'font-lock-function-name-face))

;; Use a theme.
;(load-theme 'modus-operandi t)  ; Light theme
(load-theme 'modus-vivendi t)  ; Dark theme

;; Set font based on operating system.
(cond
 ((string-equal system-type "gnu/linux")
  (progn
    (add-to-list 'default-frame-alist '(font . "Berkeley Mono-11"))))
 ((string-equal system-type "windows-nt")
  (progn
    (add-to-list 'default-frame-alist '(font . "Berkeley Mono")))))

;; Use ~/.todo.org for the org-mode agenda.
(cond
 ((string-equal system-type "gnu/linux")
  (progn
    (setq org-agenda-files '("~/.todo.org")))))

;; Main options that don't come under other sections.
(add-to-list 'default-frame-alist '(height . 35))
(add-to-list 'default-frame-alist '(width . 132))
(c-set-offset 'arglist-cont-nonempty '4)
(electric-pair-mode 1)
(global-whitespace-mode 1)
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(setq auto-save-default nil
      backup-inhibited t
      calendar-week-start-day 1
      colon-double-space nil
      column-number-mode t
      inhibit-startup-screen t
      line-move-visual nil
      mouse-wheel-progressive-speed nil
      mouse-wheel-scroll-amount '(4 ((shift) . 1) ((control) . 8))
      org-log-done 'time
      org-startup-folded nil
      org-startup-truncated nil
      org-todo-keywords '((sequence "TODO(t)"
                                    "WAITING(w)"
                                    "|"
                                    "DONE(d)"
                                    "CANCELLED(c)"))
      sentence-end-double-space nil
      shr-inhibit-images t
      shr-use-fonts nil
      track-eol t
      visible-bell t
      whitespace-line-column 100
      whitespace-style '(face lines-tail trailing tabs tab-mark)
      x-super-keysym 'meta)
(setq-default fill-column 72
              frame-title-format '("%b")
              indent-tabs-mode nil
              olivetti-body-width 102
              tab-width 8)
(show-paren-mode t)
(setq exec-path (append exec-path '("~/.cargo/bin")))

;; Set up Magit.
(global-set-key (kbd "C-x g") 'magit-status)

;; Programming-related config should go into this file, as it can get
;; quite long and complicated.
(setq acp-programming-file (expand-file-name "programming.el" user-emacs-directory))
(if (file-readable-p (symbol-value 'acp-programming-file))
    (load acp-programming-file))

;; Set and read the external (non checked-in) Custom file. This
;; section should always be at the end of the file.
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(if (file-readable-p (symbol-value 'custom-file))
    (load custom-file))
