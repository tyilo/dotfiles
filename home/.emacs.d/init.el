
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(setq evil-want-C-u-scroll t)
(setq-default indent-tabs-mode nil)

;; Ensure el-get is installed
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")

(el-get-bundle color-theme-sanityinc-tomorrow)
(el-get-bundle auto-complete)
(el-get-bundle undo-tree)
(el-get-bundle ido-ubiquitous)
(el-get-bundle rainbow-delimiters)
(el-get-bundle evil)
(el-get-bundle sml-mode)

(el-get-bundle fstar-mode)

(el-get 'sync)

(global-undo-tree-mode)

;; Activate evil
(evil-mode 1)
(evil-ex-define-cmd "W" "write")

(add-to-list 'auto-mode-alist '("\\.lex\\'" . sml-lex-mode))
(add-to-list 'auto-mode-alist '("\\.mml\\'" . sml-mode))

;; scroll one line at a time (less "jumpy" than defaults)

(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time

(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling

(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse

(setq scroll-step 1) ;; keyboard scroll one line at a time

(setq inhibit-startup-message t)  ; dont show the GNU splash screen
(transient-mark-mode t)           ; show selection from mark
(show-paren-mode t)               ; turn on highlight paren mode
(fset 'yes-or-no-p 'y-or-n-p)     ; use y and n for questions
(global-font-lock-mode t)         ; enable syntax highlighting
(iswitchb-mode 1)                 ; better buffer switching
(setq scheme-program-name "/usr/bin/petite")
(load-file                "~/.emacs.d/scheme/scheme_setup.el")

(load-file "~/.emacs.d/bnf-mode.el")

; Only left option key is meta
(setq mac-option-key-is-meta t)
(setq mac-right-option-modifier nil)

; Line numbers
(global-linum-mode)

(defvar --backup-directory (concat user-emacs-directory "backups"))
(if (not (file-exists-p --backup-directory))
        (make-directory --backup-directory t))
(setq backup-directory-alist `(("." . ,--backup-directory)))
(setq make-backup-files t               ; backup of a file the first time it is saved.
      backup-by-copying t               ; don't clobber symlinks
      version-control t                 ; version numbers for backup files
      delete-old-versions t             ; delete excess backup files silently
      kept-old-versions 6               ; oldest versions to keep when a new numbered backup is made (default: 2)
      kept-new-versions 9               ; newest versions to keep when a new numbered backup is made (default: 2)
      auto-save-default t               ; auto-save every buffer that visits a file
      auto-save-timeout 20              ; number of seconds idle time before auto-save (default: 30)
      auto-save-interval 200            ; number of keystrokes between auto-saves (default: 300)
      )


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (sanityinc-tomorrow-bright)))
 '(custom-safe-themes
   (quote
    ("1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" default)))
 '(package-selected-packages (quote (fstar-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


(color-theme-sanityinc-tomorrow-bright)
