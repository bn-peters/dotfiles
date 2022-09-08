;; Install straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; disable package.el
(setq package-enable-at-startup nil)
;; automatically call straight.el when importing using use-package
(setq straight-use-package-by-default t)

;; Disable menu and tool bars
(menu-bar-mode -1)
(tool-bar-mode -1)

;; Disable start screen
(setq inhibit-startup-screen t)

;; enable line wrapping
(global-visual-line-mode)

;; Disable beeps
(setq ring-bell-function 'ignore)

;; Install use-package
(straight-use-package 'use-package)


;; Use-package declarations
; :init      before a package is loaded
; :config    after a package is loaded
; :custom    set variables. can be emulated by setq in :config
; :general   keybinds using general.el
; :defer     TODO

;; Install theme
(use-package spacemacs-theme
             ; no idea what defer does here, but its required
             :defer t 
             :init
             ; also available: spacemacs-light
             (load-theme 'spacemacs-dark t))

;; general.el: advanced keyboard shortcuts
; TODO use all available features
(use-package general)

;; which-key: show possible keys to follow
(use-package which-key
             :config
             (which-key-mode 1))


;; vertico: Vertical completion framework
(use-package vertico
             :general
             ("M-x" 'execute-extended-command)
             :init
             (vertico-mode 1))
;; orderless: completion style
(use-package orderless
             :custom
             (completion-styles '(orderless basic)))

;; Vim keybinds
(use-package evil
             :init
             (setq evil-want-keybinding nil)
             :config
             ;; enable evil mode verywhere
             (evil-mode 1)
             ;; unbind return in evil mode to allow org-return-follows-link to work
             (define-key evil-motion-state-map (kbd "RET") nil)
             (define-key evil-motion-state-map (kbd "TAB") nil))

;; TODO understand consult
;; TODO has ripgrep?
(use-package consult
             ;; Use `consult-completion-in-region' if Vertico is enabled.
             ;; Otherwise use the default `completion--in-region' function.
             :config
             (setq completion-in-region-function
                   (lambda (&rest args)
                     (apply (if vertico-mode
                                #'consult-completion-in-region
                              #'completion--in-region)
                            args))))

;; Replaces file associations
(use-package openwith
             :custom
             ;; Ensure PDFs are opened with Okular
             (openwith-associations '(("\\.pdf\\'" "okular" (file))))
             :config
             (openwith-mode t))

;; org
(use-package org
             :general
             (:states '(normal) "SPC o h" 'consult-org-heading)
             (:states '(normal) "SPC o c" 'org-capture)
             (:states '(normal) "SPC o a" 'org-agenda)
             (:states '(normal) "SPC o n" (lambda () (interactive) (find-file "~/org/notes.org")))
             (:states '(normal) :keymaps 'org-mode-map "SPC m t" 'org-set-tags-command)
             (:states '(normal) :keymaps 'org-mode-map "SPC m d i" 'org-time-stamp)
             (:states '(normal) :keymaps 'org-mode-map "SPC m d s" 'org-schedule)
             (:states '(normal) :keymaps 'org-mode-map "SPC m d d" 'org-deadline)
             :hook (org-mode . org-indent-mode)
             :config
             ;; Use return to open links in org mode
             (setq org-return-follows-link t)
             ;; Always open things in the same buffer
             (setf (cdr (assoc 'file org-link-frame-setup)) 'find-file)
             ;; set the org directory
             (setq org-directory "~/org")
             ; ;; Set default org file
             (setq org-default-notes-file "~/org/notes.org")
             (setq org-capture-templates '(("n" "Note" entry (file "~/org/notes.org") 
                                            "* IN-PROGRESS %?" :empty-lines 1)
                                           ("N" "Notelet" entry (file "~/org/notelets.org")
                                            "* %?" :empty-lines 1)
                                           ("m" "Meeting" entry (file "~/org/notes.org")
                                            "* Meeting %? %u" :empty-lines 1)
                                           ("t" "Todo" entry (file "~/org/notes.org")
                                            "* TODO %?" :empty-lines 1)))
             (setq org-agenda-files '("~/org/notes.org" "~/org/notelets.org"))
             (setq org-todo-keywords
                   '((sequence "TODO" "WORKING" "|" "DONE" "CLOSED")
                     (sequence "NOTE" "PROJECT" "WIP" "TEMP" "|")))
             (setq org-todo-keyword-faces '(("TODO" . org-todo)
                                            ("WORKING" . "yellow")
                                            ("DONE" . org-done)
                                            ("CLOSED" . org-warning)
                                            ("NOTE" . "blue")
                                            ("PROJECT" . "purple")
                                            ("WIP" . "yellow")
                                            ("TEMP" . "gray")))
             (setq org-startup-folded t)
             (setq org-agenda-prefix-format '((agenda . " %i %-12:c%?-12t% s %b")
                                             (todo . " %i %-12:c")
                                             (tags . " %i %-12:c")
                                             (search . " %i %-12:c")))
             (setq org-agenda-breadcrumbs-separator "/"))

(use-package mixed-pitch
             :hook
             (org-mode . mixed-pitch-mode)
             :config
             (set-face-attribute 'default nil :font "Fira Code Retina" :height 120)
             (set-face-attribute 'fixed-pitch nil :font "Fira Code Retina" :height 120)
             (set-face-attribute 'variable-pitch nil :font "Source Serif Pro" :height 120))


;; Fancy bullets in front of headings
(use-package org-bullets
             :after (org)
             :init
             (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

;; Vim keybinds in org mode
(use-package evil-org
             :after (org evil)
             ;; Enable evil org mode
             :hook (org-mode . evil-org-mode)
             :config
             (require 'evil-org-agenda)
             (evil-org-set-key-theme 
               '(navigation insert textobjects additional calendar))
             (evil-org-agenda-set-keys))


; ;; Org roam: Note taking
; (use-package org-roam
;              :general
;              (:states '(normal) "SPC o o" 'org-roam-node-find)
;              (:states '(normal) "SPC o r" 'org-roam-ref-find)
;              (:states '(normal) "SPC o b" 'org-roam-buffer-toggle)
;              (:states '(normal) :keymaps 'org-mode-map "SPC m t" 'org-roam-tag-add)
;              (:states '(normal) :keymaps 'org-mode-map "SPC m l" 'org-roam-node-insert)
;              (:states '(normal) :keymaps 'org-mode-map "SPC m r" 'org-roam-ref-add)
;              :custom
;              (org-roam-directory "/home/silvus/org")
;              (org-roam-setup)
;              (org-roam-capture-templates '(("n" "note" plain "* ${title}\n\n%?"
;                                            :target (file+head "${slug}.org"
;                                                               "#+title: ${title}\n\n")
;                                            :unnarrowed t)
;                                            ; ("m" "meeting" plain "* ${title} %u \n\n%?"
;                                            ; :target (file+head "${slug}.org"
;                                            ;                    "#+title: ${title} %u \n#+filetags: :meeting:\n\n")
;                                            ; :unnarrowed t)))
;                                            ))
;              :config
;              (org-roam-db-autosync-mode)
;              (setq org-roam-node-display-template
;                    (concat "${title:*} "
;                            (propertize "${tags:40}" 'face 'org-tag))))

;; citar: citations in emacs, particularly in org mode
(use-package citar
             :general
             (:states '(normal) :keymaps 'org-mode-map "SPC m c" 'org-cite-insert)
             (:states '(normal) :keymaps 'org-mode-map "SPC c i" 'org-cite-insert)
             (:states '(normal) :keymaps 'org-mode-map "SPC c f" 'citar-open-files)
             :custom
             (org-cite-global-bibliography '("~/org/references.bib"))
             (citar-library-paths '("~/org/library/"))
             (org-cite-insert-processor 'citar)
             (org-cite-follow-processor 'citar)
             (org-cite-activate-processor 'citar)
             (citar-bibliography org-cite-global-bibliography))

;; deft: full-text search notes in specific directory
;; TODO could be replaced by ag/ripgrep/...
(use-package deft
             :general
             (:states '(normal) "SPC o d" 'deft)
             :custom
             (deft-directory "~/org/")
             :config 

    ; Workaround to improve compatability with org mode files
    (defun cm/deft-parse-title (file contents)
    "Parse the given FILE and CONTENTS and determine the title.
  If `deft-use-filename-as-title' is nil, the title is taken to
  be the first non-empty line of the FILE.  Else the base name of the FILE is
  used as title."
      (let ((begin (string-match "^#\\+[tT][iI][tT][lL][eE]: .*$" contents)))
	(if begin
	    (string-trim (substring contents begin (match-end 0)) "#\\+[tT][iI][tT][lL][eE]: *" "[\n\t ]+")
	  (deft-base-filename file))))
  
    (advice-add 'deft-parse-title :override #'cm/deft-parse-title)
  
    (setq deft-strip-summary-regexp
	  (concat "\\("
		  "[\n\t]" ;; blank
		  "\\|^#\\+[[:alpha:]_]+:.*$" ;; org-mode metadata
		  "\\|^:PROPERTIES:\n\\(.+\n\\)+:END:\n"
		  "\\)")))

;; org-ql: Advanced search framework
(use-package org-ql)
;; helm: Another completion framework. For helm-org-ql
(use-package helm)
(use-package helm-org-ql
             :general
             (:states '(normal) "SPC o q" 'helm-org-ql-directory))

(use-package magit)
(use-package evil-collection
             :config
             (evil-collection-init '(magit)))

(use-package company
             :config
             (add-hook 'after-init-hook 'global-company-mode)
             (setq company-minimum-prefix-length 2)
             (setq company-idle-delay 0.25)
             (add-to-list 'company-backends 'company-capf))
