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
;; automatically use straight.el when importing using use-package
(setq straight-use-package-by-default t)

;; Disable warnings from native comp
;(setq native-comp-async-report-warnings-errors nil)
(setq warning-minimum-level :error)

;; Disable menu and tool bars
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)


;; Enable transparency
; (set-frame-parameter nil 'alpha-background 70) ; For current frame
; (add-to-list 'default-frame-alist '(alpha-background . 70)) ; For all new frames henceforth


;; Enable line numbers
(global-display-line-numbers-mode 1)

;; Disable start screen
(setq inhibit-startup-screen t)

;; enable line wrapping
(global-visual-line-mode)

;; set behavior when cursor leaves screen
(setq scroll-conservatively 1)
(setq scroll-margin 5)

;; Disable beeps
(setq ring-bell-function 'ignore)

;; Enable pairing
(electric-pair-mode)


;; Set default fonts
(set-face-attribute 'default nil :font "Fira Code Retina" :height 120)
(set-face-attribute 'fixed-pitch nil :font "Fira Code Retina" :height 120)
(set-face-attribute 'variable-pitch nil :font "Source Serif Pro" :height 120)

;; Install use-package
(straight-use-package 'use-package)


;; Use-package declarations
; :init      before a package is loaded
; :config    after a package is loaded
; :custom    set variables. can be emulated by setq in :config
; :general   keybinds using general.el
; :defer     TODO

;; Install theme
; (use-package spacemacs-theme
;              ; no idea what defer does here, but its required
;              :defer t 
;              :init
;              ; also available: spacemacs-light
;              (load-theme 'spacemacs-dark t))
(use-package dracula-theme
             ; no idea what defer does here, but its required
             :defer t 
             :init
             ; also available: spacemacs-light
             (load-theme 'dracula t))

;; general.el: advanced keyboard shortcuts
(use-package general)

;; which-key: show possible keys to follow
(use-package which-key
             :config
             (which-key-mode 1))

(general-create-definer def-key-notes 
                        :states '(normal) 
                        :prefix "SPC n")
(def-key-notes 
  "" '(nil :which-key "notes"))
(general-create-definer def-key-citations 
                        :states '(normal) 
                        :prefix "SPC c")
(def-key-citations 
  "" '(nil :which-key "citations"))


(general-create-definer def-key-files 
                        :states '(normal) 
                        :prefix "SPC f")
(def-key-files 
  "" '(nil :which-key "files")
  "f" 'find-file
  "d" 'delete-file
  ; TODO move this to a more reasonable category
  ; TODO think about what to do with symlinks, cf https://stackoverflow.com/a/30900018
  "c" '((lambda () (interactive) (find-file "~/.config/emacs/init.el")) 
  	:which-key "open config"))

(general-create-definer def-key-org 
                        :states '(normal) 
                        :keymaps 'org-mode-map 
                        :prefix "SPC m")
(def-key-org
  "" '(nil :which-key "mode"))

(general-create-definer def-key-toggles
			:states '(normal)
			:prefix "SPC t")
(def-key-toggles
 "" '(nil :which-key "toggles")
 "l" 'display-line-numbers-mode
 "m" 'mixed-pitch-mode
 ; TODO enable line numbers everywhere except in org, markdown, etc
 "h" 'hl-line-mode)

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
             ;; unbind keys in evil mode
             (define-key evil-motion-state-map (kbd "RET") nil)
             (define-key evil-normal-state-map (kbd "C-.") nil)
             (define-key evil-motion-state-map (kbd "TAB") nil))

;; TODO understand consult
;; TODO has ripgrep?
(use-package consult
             ;; Use `consult-completion-in-region' if Vertico is enabled.
             ;; Otherwise use the default `completion--in-region' function.
             :config
             (setq completion-in-region-functio
                   (lambda (&rest args)
                     (apply (if vertico-mode
                                #'consult-completion-in-region
                              #'completion--in-region)
                            args))))

(use-package embark
             :bind
             (("C-." . embark-act)))
(use-package marginalia
             :config 
             (marginalia-mode))

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
             (def-key-notes "h" 'consult-org-heading
                            "t" '((lambda () (interactive) (org-capture nil "n"))
                                  :which-key "org-capture" )
			              ; "t" 'org-capture
                            "a" 'org-agenda
                            "T" '((lambda () (interactive) (find-file "~/org/notes.org")) 
                                  :which-key "open notes.org"))
             (def-key-org "d" '(nil :which-key "dates")
                          "d i" 'org-time-stamp
                          "d s" 'org-schedule
                          "d d" 'org-deadline)
             :hook (org-mode . org-indent-mode)
             :config
	     ;; disable line numbers in org mode
	     (add-hook 'org-mode-hook (lambda () (display-line-numbers-mode 0)))
             ;; Use return to open links in org mode
             (setq org-return-follows-link t)
             ;; Always open things in the same buffer
             (setf (cdr (assoc 'file org-link-frame-setup)) 'find-file)
             (setq org-capture-templates '(("n" "Note" entry (file "~/org/notes.org") 
                                            "* %?" :empty-lines 1)))
             (setq org-agenda-files '("~/org"))
             (setq org-todo-keywords
                   '((sequence "TODO" "WORKING" "|" "DONE" "CLOSED")
                     (sequence "PROJECT" "WIP" "TEMP" "|")))
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
             (setq org-agenda-breadcrumbs-separator "/")
             ;; Size of latex preview
             (setq org-format-latex-options (plist-put org-format-latex-options :scale 1.35))
             (setq org-format-latex-options (plist-put org-format-latex-options :background "Transparent")) )

(use-package mixed-pitch
             :hook
             (org-mode . mixed-pitch-mode))


;; Fancy bullets in front of headings
(use-package org-bullets
             :after (org)
             :init
             (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

;; Disable latex preview when hovering them
(use-package org-fragtog
             :after (org)
             :init
             (add-hook 'org-mode-hook 'org-fragtog-mode))
;; Disable formatting when hovering
(use-package org-appear
             :after (org)
	     :config
	     (setq org-hide-emphasis-markers t)
	     (setq org-appear-autolinks t)
	     (setq org-startup-with-latex-preview t)
	     ; only use org appear in insert mode
	     ; from https://stackoverflow.com/questions/10969617/hiding-markup-elements-in-org-mode
 	     (setq org-appear-trigger 'manual)
 	     (add-hook 'org-mode-hook (lambda ()
                           (add-hook 'evil-insert-state-entry-hook
                                     #'org-appear-manual-start
                                     nil
                                     t)
                           (add-hook 'evil-insert-state-exit-hook
                                     #'org-appear-manual-stop
                                     nil
                                     t)))
             :init
             (add-hook 'org-mode-hook 'org-appear-mode))

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
(use-package org-roam
             :general
             (def-key-notes "n" 'org-roam-node-find)
             (def-key-org "t" 'org-roam-tag-add
                          "b" 'org-roam-buffer-toggle
                          "l" 'org-roam-node-insert)
             :custom
             (org-roam-directory "/home/silvus/org")
             (org-roam-setup)
             (org-roam-capture-templates '(("n" "note" plain "* ${title}\n\n%?"
                                           :target (file+head "${slug}.org"
                                                              "#+title: ${title}\n\n")
                                           :unnarrowed t)
                                           ; ("m" "meeting" plain "* ${title} %u \n\n%?"
                                           ; :target (file+head "${slug}.org"
                                           ;                    "#+title: ${title} %u \n#+filetags: :meeting:\n\n")
                                           ; :unnarrowed t)))
                                           ))
             :config
             (org-roam-db-autosync-mode)
             (setq org-roam-node-display-template
                   (concat "${title:*} "
                           (propertize "${tags:40}" 'face 'org-tag))))

;; citar: citations in emacs, particularly in org mode
(use-package citar
             :general
             (def-key-org "c" 'org-cite-insert)
             (def-key-citations "f" 'citar-open-files
                                "i" 'org-cite-insert)
             :custom
             (org-cite-global-bibliography '("~/org/references.bib"))
             (citar-library-paths '("~/org/library/"))
             (org-cite-insert-processor 'citar)
             (org-cite-follow-processor 'citar)
             (org-cite-activate-processor 'citar)
             (citar-bibliography org-cite-global-bibliography))
(use-package citar-embark 
             :after citar embark
             :config
             (citar-embark-mode))

;; deft: full-text search notes in specific directory
;; TODO could be replaced by ag/ripgrep/...
(use-package deft
             :general
             (def-key-notes "d" 'deft)
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
             (def-key-notes "q" 'helm-org-ql-directory))

(use-package magit)
(use-package evil-collection
             :config
             (evil-collection-init '(magit)))

(use-package company
             :config
             (add-hook 'after-init-hook 'global-company-mode)
             (setq company-minimum-prefix-length 0)
             (setq company-idle-delay 0.05)
             (add-to-list 'company-backends 'company-capf)
             (company-tng-configure-default)
	     :custom-face
	     ; Avoid ragged lines for completion
	     ; TODO make this coincide with "default" type face from mixed pitch mode
	     (company-tooltip ((t (:family "Fira Code Retina")))))
