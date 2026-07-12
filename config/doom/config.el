;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file! Reload it live with 'SPC h r r', or a
;; restart. ('init.el' and 'packages.el' DO need 'doom sync'.)

;;; ----------------------------------------------------------------------------
;;; Identity
;;; ----------------------------------------------------------------------------

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Stefan Imhoff"
      user-mail-address "gpg@kogakure.8shield.net")

;;; ----------------------------------------------------------------------------
;;; UI: theme & appearance
;;; ----------------------------------------------------------------------------

;; This is the default way to load a theme. Both `doom-theme' and a manual
;; `load-theme' call assume the theme is installed and available.
(setq doom-theme 'catppuccin)
(setq catppuccin-flavor 'mocha)

;; Relative line numbers (like LazyVim's default) — good for evil counts
;; such as '5j' or 'd3k'.
(setq display-line-numbers-type 'relative)

;; Show available key bindings promptly. LazyVim waits 300 ms; the shorter
;; delay compensates for terminal Emacs' additional popup/rendering overhead.
(after! which-key
  (setq which-key-idle-delay 0.15)

  ;; Like which-key.nvim: Backspace returns to the previous prefix menu.
  (defun +which-key-go-back ()
    (interactive)
    ;; `this-command-keys-vector' ends with the current prefix key and DEL.
    ;; Replay everything before those two events to reopen the parent prefix.
    (which-key-reload-key-sequence
     (butlast (listify-key-sequence (this-command-keys-vector)) 2)))

  (defun +which-key-bind-backspace (map &optional seen)
    "Bind Backspace in MAP and all of its nested prefix maps."
    (let ((seen (or seen (make-hash-table :test #'eq))))
      (unless (gethash map seen)
        (puthash map t seen)
        (map-keymap
         (lambda (_event binding)
           (when (keymapp binding)
             (+which-key-bind-backspace binding seen)))
         map)
        (define-key map (kbd "DEL") #'+which-key-go-back)
        (define-key map (kbd "<backspace>") #'+which-key-go-back))))

  (+which-key-bind-backspace doom-leader-map))

;; Let the terminal's own (possibly transparent) background show through
;; instead of Emacs painting an opaque one. This only applies to `emacs -nw`;
;; GUI frames keep their theme background.
(defconst +tty-transparent-bg-faces
  '(default
    fringe
    line-number
    line-number-current-line
    vertical-border
    window-divider
    window-divider-first-pixel
    window-divider-last-pixel
    header-line
    tab-bar
    tab-bar-tab
    tab-bar-tab-inactive
    tab-line
    tab-line-tab
    tab-line-tab-current
    tab-line-tab-inactive
    mode-line
    mode-line-active
    mode-line-inactive
    doom-modeline-bar
    doom-modeline-bar-inactive
    solaire-default-face
    solaire-fringe-face
    solaire-line-number-face
    solaire-header-line-face
    solaire-mode-line-face
    solaire-mode-line-active-face
    solaire-mode-line-inactive-face)
  "Faces whose background should inherit the terminal background in TTY Emacs.")

(defconst +tty-transparent-bg-colors
  '("#1e1e2e" "#181825" "#11111b" "#313244" "#292c3c")
  "Theme background colors to clear in TTY Emacs.")

(defun +tty-transparent-bg--clear-face (face frame)
  (set-face-background face "unspecified-bg" frame)
  (set-face-background face "unspecified-bg"))

(defun +tty-transparent-bg (&optional frame)
  (let ((frame (or frame (selected-frame))))
    (unless (display-graphic-p frame)
      (dolist (face +tty-transparent-bg-faces)
        (when (facep face)
          (+tty-transparent-bg--clear-face face frame)))
      (dolist (face (face-list))
        (when (member (face-attribute face :background frame 'default)
                      +tty-transparent-bg-colors)
          (+tty-transparent-bg--clear-face face frame))))))

(add-hook 'doom-load-theme-hook #'+tty-transparent-bg)
(add-hook 'server-after-make-frame-hook #'+tty-transparent-bg)
(add-hook 'window-setup-hook #'+tty-transparent-bg)
(add-hook 'after-change-major-mode-hook #'+tty-transparent-bg)
(+tty-transparent-bg)

(after! solaire-mode
  (solaire-global-mode -1)
  (+tty-transparent-bg))

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;;; ----------------------------------------------------------------------------
;;; Editor behaviour
;;; ----------------------------------------------------------------------------

;; Use a slim bar cursor while typing; keep Evil's defaults in other states.
(after! evil
  (setq evil-insert-state-cursor '(bar . 2)))

;; 2-space indentation everywhere (matches nvim's shiftwidth/tabstop = 2).
(setq-default tab-width 2)
(setq-default evil-shift-width 2)      ; how far >> / << shift in evil
(setq-default standard-indent 2)

;; Auto-save visited files (approximates nvim's `autowrite`).
(setq auto-save-default t)

;;; ----------------------------------------------------------------------------
;;; Keybindings (mirror NeoVim muscle memory)
;;; ----------------------------------------------------------------------------

;; Leader (SPC) maps — same style as LazyVim's <leader> menus.
(map! :leader
      :desc "Avy jump"           "j j" #'avy-goto-char-timer          ; existing
      :desc "Toggle whitespace"  "t w" #'whitespace-mode              ; ~ nvim <leader>ut (SPC u is universal-argument, not a prefix)
      :desc "Kill other buffers" "b x" #'doom/kill-other-buffers)     ; ~ nvim <leader>bx

;; Window navigation on C-h/j/k/l (nvim smart-splits).
(map! :n "C-h" #'evil-window-left
      :n "C-j" #'evil-window-down
      :n "C-k" #'evil-window-up
      :n "C-l" #'evil-window-right)

;; Stay in visual mode after re-indenting (nvim `<gv` / `>gv`).
;; evil-shift-left/-right normally exit visual mode; evil-visual-restore
;; re-enters it on the just-shifted region, same effect as nvim's `gv`.
(map! :v "<" (cmd! (evil-shift-left (region-beginning) (region-end))
                    (evil-visual-restore))
      :v ">" (cmd! (evil-shift-right (region-beginning) (region-end))
                    (evil-visual-restore)))

;; Center the window on the next/prev search match (nvim `nzzzv`).
;; Doom's `/` is evil's ex-search, so `n`/`N` must call the ex-search
;; movers (evil-search-next/-previous are the *other*, unused module).
(map! :n "n" (cmd! (evil-ex-search-next) (evil-scroll-line-to-center nil))
      :n "N" (cmd! (evil-ex-search-previous) (evil-scroll-line-to-center nil)))

;; Fold open/close on +/- (nvim map). The `fold` module (init.el) provides
;; the backend evil-open-fold/evil-close-fold hook into.
(map! :n "+" #'evil-close-fold
      :n "-" #'evil-open-fold)

;;; ----------------------------------------------------------------------------
;;; macOS integration
;;; ----------------------------------------------------------------------------

;; Open current file in iA Writer (nvim <leader>wi).
(defun +open-in-ia-writer ()
  "Open the current buffer's file in iA Writer.app."
  (interactive)
  (when buffer-file-name
    (call-process "open" nil 0 nil "-a" "iA Writer.app" buffer-file-name)))
(map! :leader :desc "Open in iA Writer" "w i" #'+open-in-ia-writer)

;;; ----------------------------------------------------------------------------
;;; Frontend / web dev (TypeScript, React, Next.js, Astro, CSS)
;;; ----------------------------------------------------------------------------

;; `javascript' and `web' modules (init.el) already cover TS/JS/JSX/TSX and
;; HTML/CSS with lsp-mode + tree-sitter. Astro needs one more line: lsp-mode
;; ships an astro-ls client keyed off the *filename* ("\\.astro$"), not a
;; major mode — so all that's missing is a mode to edit .astro files in.
;; web-mode (already pulled in by the `web' module) handles the mixed
;; HTML/JS/CSS syntax well enough, and its lsp-deferred hook (from `+lsp')
;; does the rest automatically.
(add-to-list 'auto-mode-alist '("\\.astro\\'" . web-mode))

;;; ----------------------------------------------------------------------------
;;; Org
;;; ----------------------------------------------------------------------------

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
