;; .emacs.d/programming.el
;; Anthony Perkins
;; https://code.acperkins.com/acp/emacs.d

;; Copy or symlink this file to programming.el to include it by default.

;; Initialise packages.
(require 'cc-mode)
(require 'company)
(require 'lsp)
(require 'company-lsp)
(require 'lsp-clients)
(require 'lsp-rust)
(require 'rust-mode)
(add-hook 'c-mode-hook 'lsp)
(add-hook 'c++-mode-hook 'lsp)
(push 'company-lsp company-backends)
(add-hook 'after-init-hook 'global-company-mode)
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;; Assign keyboard shortcuts for individual modes.
(defun my-indent-relative-first-only ()
  (interactive)
  (indent-relative t nil))
(define-key c-mode-map (kbd "<C-tab>") 'my-indent-relative-first-only)

;; Define C and C++ formatting styles.
(c-add-style "microsoft" '("stroustrup"
               (c-offsets-alist
                (innamespace . -)
                (inline-open . 0)
                (inher-cont . c-lineup-multi-inher)
                (arglist-cont-nonempty . +)
                (template-args-cont . +))))
(setq c-default-style "microsoft")
(setq-default c-basic-offset 8)

(defun my-enable-tabs-mode ()
  (setq indent-tabs-mode t))
(add-hook 'c-mode-hook 'my-enable-tabs-mode)
(add-hook 'c++-mode-hook 'my-enable-tabs-mode)
