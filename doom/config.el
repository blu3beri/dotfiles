;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "Berend Sliedrecht"
      user-mail-address "blu3beri@proton.me")

(setq my/light-theme 'doom-one
      my/dark-theme 'doom-old-hope)

(setq display-line-numbers-type t
      org-directory "~/org/"
      scroll-step 1
      scroll-margin 7)

(global-hide-mode-line-mode)

(defun my/apply-theme (appearance)
  "Load theme, taking current system APPEARANCE into consideration."
  (mapc #'disable-theme custom-enabled-themes)
  (pcase appearance
    ('light (load-theme my/light-theme t))
    ('dark (load-theme my/dark-theme t))))

(add-hook 'ns-system-appearance-change-functions #'my/apply-theme)

(setq doom-theme my/dark-theme)
(setq doom-font (font-spec :family "Hack Nerd Font" :size 14.0))

(defun split-and-browse ()
  "Vertically split window and browse url"
  (interactive)
  (if (string-match-p "xwidget" system-configuration-options)
  (let (url)
    (setq url (read-string "Enter url: "))
    (+evil/window-vsplit-and-follow)
    (xwidget-webkit-browse-url url t))
  (message "No xwidget support")))

(map! :leader
      :prefix "o"
      "x" 'split-and-browse)

(map! :after evil
      :n "j"   #'evil-next-visual-line
      :n "k"   #'evil-previous-visual-line
      :n "C-h" #'evil-window-left
      :n "C-j" #'evil-window-down
      :n "C-k" #'evil-window-up
      :n "C-l" #'evil-window-right)

(map! :leader
      "k" 'magit
      "t" #'+vterm/toggle)

(map! :leader
      :prefix "o"
      "p" #'neotree-toggle)

(map! :after lsp-mode
      :leader
      :mode lsp-mode
      "]" #'lsp-eslint-apply-all-fixes
      "[" #'prettier-prettify
      "e" #'flycheck-display-error-at-point
      "a" #'lsp-execute-code-action)

(map! :after lsp-mode
      "C-SPC" #'company-complete)

(map! :after lsp-ui
      :map lsp-ui-doc-mode-map
      :n "K" #'lsp-ui-doc-glance
      :n "C-K" #'lsp-ui-doc-focus-frame)

(use-package! lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l")
  :config
  (setq lsp-headerline-breadcrumb-enable nil
        lsp-ui-doc-show-with-mouse nil
        lsp-ui-doc-show-with-cursor nil
        lsp-enable-symbol-highlighting nil
        lsp-ui-sideline-enable nil
        lsp-modeline-code-actions-enable nil
        lsp-eldoc-enable-hover nil
        lsp-signature-auto-activate nil
        lsp-modeline-diagnostics-enable nil
        lsp-lens-enable nil)
  :hook
  (typescript-mode . lsp-deferred)
  (rust-mode . lsp-deferred)
  (eslint-mode . lsp-deferred)
  :commands lsp lsp-deferred)

(use-package! lsp-ui
  :after lsp-mode
  :commands lsp-ui-mode)

(use-package! company
  :after lsp-mode
  :hook
  (global-company-mode)
  :config
  (setq company-idle-delay nil))

(use-package! typescript-mode
  :after lsp-mode)

(use-package! lsp-ivy
  :commands lsp-ivy-workspace-symbol)

(use-package! which-key
  :config
  (which-key-mode))

(use-package! flycheck
  :config
  (setq flycheck-display-errors-delay 5
        flycheck-idle-buffer-switch-delay 5
        flycheck-idle-change-delay 5))

(after! neotree
  (setq neo-theme nil))
