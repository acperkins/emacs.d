;; .emacs.d/init.el
;; Anthony Perkins
;; https://git.acperkins.com/acp/emacs.d

;; Reduce cramp from common keyboard shortcuts.
(define-key key-translation-map (kbd "<f9>") (kbd "M-x"))

;; Include any non checked-in packages in the ".emacs.d/site-lisp"
;; directory and checked-in packages in the ".emacs.d/lisp" directory.
(add-to-list 'load-path (expand-file-name "site-lisp" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;; Prefer UTF-8 encoding for all files.
(prefer-coding-system 'utf-8)

;; Run the whole buffer through an external command.
;; Source: <https://www.emacswiki.org/emacs/ExecuteExternalCommand>
(defun shell-command-on-buffer ()
  "Asks for a command and executes it in inferior shell with current buffer as input."
  (interactive)
  (shell-command-on-region
   (point-min)(point-max)
   (read-shell-command "Shell command on buffer: ")
   nil t))

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

(when (member "Iosevka Term" (font-family-list))
  (set-default-font "Iosevka Term Light-12"))

;; Main options that don't come under other sections.
(c-set-offset 'arglist-cont-nonempty '4)
(define-key global-map "\C-ck" 'kill-this-buffer)
(load-theme 'tango)
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(setq auto-save-default nil
      backup-inhibited t
      c-default-style "bsd"
      calendar-week-start-day 1
      colon-double-space nil
      default-frame-alist '((cursor-color . "grey"))
      inhibit-startup-screen t
      line-move-visual nil
      mouse-wheel-progressive-speed nil
      mouse-wheel-scroll-amount '(1 ((shift) . 1) ((control) . nil))
      org-startup-folded nil
      org-startup-truncated nil
      org-log-done 'time
      sentence-end-double-space t
      shr-inhibit-images t
      shr-use-fonts nil
      track-eol t
      whitespace-style '(space-mark tab-mark newline-mark)
      x-super-keysym 'meta)
(setq-default indent-tabs-mode nil
              c-basic-offset 4
              fill-column 78
              frame-title-format '("%b"))
(show-paren-mode t)

;; Set and read the external (non checked-in) Custom file. This
;; section should always be at the end of the file.
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(if (file-readable-p (symbol-value 'custom-file))
    (load custom-file))
