(setq delete-old-versions -1 )		; delete excess backup versions silently
(setq version-control t )		; use version control
(setq vc-make-backup-files t )		; make backups file even when in version controlled dir
(setq backup-directory-alist `(("." . "~/.emacs.d/backups")) ) ; which directory to put backups file
(setq vc-follow-symlinks t )				       ; don't ask for confirmation when opening symlinked file
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)) ) ;transform backups file name
(setq inhibit-startup-screen t )	; inhibit useless and old-school startup screen
(setq ring-bell-function 'ignore )	; silent bell when you make a mistake
(setq coding-system-for-read 'utf-8 )	; use utf-8 by default
(setq coding-system-for-write 'utf-8 )
(setq sentence-end-double-space nil)	; sentence SHOULD end with only a point.
(setq default-fill-column 80)		; toggle wrapping text at the 80th character
(setq-default fill-column 80)

(require 'package)

(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives '("gnu" . (concat proto "://elpa.gnu.org/packages/")))))
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(unless (package-installed-p 'general)
(package-refresh-contents)
(package-install 'general))

(tool-bar-mode -1)
(scroll-bar-mode -1)

(require 'use-package)

(set-face-attribute 'default nil
                    :family "M+ 1M"
                    :weight 'semi-light
                    :height 160)

(add-hook 'eshell-mode-hook
	  (lambda ()
	    (define-key eshell-mode-map (kbd "<tab>")
	      (lambda () (interactive) (pcomplete-std-complete)))))

(use-package evil :ensure t
  :config
  (evil-mode 1))

(use-package rainbow-delimiters :ensure t
  :config
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

(use-package magit :ensure t)
(use-package evil-magit :ensure t)

(use-package htmlize :ensure t)
(use-package org :ensure t)
(use-package evil-org :ensure t
  :config
  (setq org-refile-targets '((nil :maxlevel . 9)
			     (org-agenda-files :maxlevel . 9)))
  (setq org-outline-path-complete-in-steps nil)
  (setq org-refile-use-outline-path t)
  (setq org-log-done 'note)
  (custom-set-variables
   '(org-startup-indented t)
   '(org-agenda-files (file-expand-wildcards "~/repos/*/org"))))
(use-package org-pomodoro :ensure t)
(use-package evil-org :ensure t)

(use-package linum-relative :ensure t
  :config
  (setq linum-relative-backend 'display-line-numbers-mode)
  (global-display-line-numbers-mode 1)
  (column-number-mode 1)
  (linum-relative-on))

(use-package fill-column-indicator :ensure t
  :config
  (setq fci-rule-color "darkblue")
  (setq fci-rule-width 2)
  (setq fci-rule-column 80))

(add-hook 'org-mode-hook 'turn-on-auto-fill 'evil-org-mode)

(use-package ox-reveal :ensure t
  :config
  (setq org-reveal-root "file:///Users/tmcknight/repos/reveal.js-3.8.0")
  (setq org-reveal-title-slide nil))

(use-package exec-path-from-shell :ensure t
  :config
  (exec-path-from-shell-initialize))

(use-package fzf :ensure t)

(use-package ivy :ensure t
  :config
  (setq ivy-use-virtual-buffers t))

(use-package flx :ensure t
  :config
  (setq ivy-re-builders-alist
        '((t . ivy--regex-fuzzy)))
  (ivy-mode 1)
  )

(use-package projectile :ensure t
  :config
  (projectile-mode 1)
  (setq projectile-completion-system 'ivy)
  (setq projectile-enable-caching t)
  )

(use-package color-theme-sanityinc-solarized :ensure t
  :config
  (load-theme 'sanityinc-solarized-light t)
  )

(use-package company :ensure t)

(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))

(use-package origami :ensure t
  :config
  (global-origami-mode))

(use-package autopair :ensure t
  :config
  (autopair-global-mode))

(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1))
(add-hook 'typescript-mode-hook #'setup-tide-mode)
(use-package tide
  :ensure t
  :config (setq company-tooltip-align-annotations t)
  :after (typescript-mode company flycheck)
  :hook ((typescript-mode . tide-setup)
         (typescript-mode . tide-hl-identifier-mode)))

(use-package markdown-mode :ensure t
  :mode (("\\.md\\'" . markdown-mode)))

(use-package which-key :ensure t
  :config
  (which-key-mode 1)
  (which-key-add-key-based-replacements
    "SPC f" "files"
    "SPC w" "windows"
    "SPC p" "projects"
    "SPC g" "git"
    "SPC s" "swiper"
    "SPC r" "search"
  )
)

(use-package counsel :ensure t)
(use-package counsel-gtags :ensure t)

(defun create-and-move-right ()
  (interactive)
  (split-window-right)
  (other-window 1))
(defun create-and-move-down ()
  (interactive)
  (split-window-below)
  (other-window 1))

(use-package general :ensure t
  :config
  (general-define-key
   :states '(normal visual emacs)
   :prefix "SPC"
   "'" 'eshell
   "x" 'counsel-M-x
   "b" 'ivy-switch-buffer
   "ff" 'counsel-find-file
   "fd" 'fzf-directory
   "fr" 'counsel-recentf
   "fp" 'fzf-git-files
   "pf" 'fzf-projectile
   "pg" 'fzf-git-files
   "pp" 'projectile-switch-project
   "pe" 'projectile-run-eshell
   "ps" 'projectile-run-shell-command-in-root
   "pa" 'projectile-run-async-shell-command-in-root
   "wv" 'split-window-right
   "wV" 'create-and-move-right
   "ws" 'split-window-below
   "wS" 'create-and-move-down
   "wl" 'evil-window-right
   "wh" 'evil-window-left
   "wj" 'evil-window-down
   "wk" 'evil-window-up
   "wd" 'evil-window-delete
   "gs" 'magit-status
   "gc" 'magit-commit
   "ga" 'magit-commit-amend
   "gl" 'magit-log
   "gm" 'magit-ediff-resolve
   "s" 'swiper
   "rg" 'counsel-git-grep
   "rp" 'projectile-grep
   ))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files (file-expand-wildcards "~/repos/*/org"))
 '(org-startup-indented t)
 '(package-selected-packages
   (quote
    (ox-reveal org-reveal autopair htmlize markdown-mode counsel-gtags fill-column-indicator org-pomodoro evil-surround tide company yaml-mode exec-path-from-shell fzf evil-org which-key use-package projectile linum-relative general flx evil-magit counsel color-theme-solarized color-theme-sanityinc-solarized htmlize origami rainbow-delimiters))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
