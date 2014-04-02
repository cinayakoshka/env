;; Frame title bar formatting to show full path of file
;; from http://www.dotfiles.com/files/6/157_.emacs.int
;; (add-hook 'before-save-hook 'whitespace-cleanup)

(setq auto-word-wrap-default-function nil)
;; (setq magic-mode-alist nil)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
			 ("marmalade" . "http://marmalade-repo.org/packages/")
			 ("melpa" . "http://melpa.milkbox.net/packages/")))

(setq-default
 frame-title-format
 (list '((buffer-file-name " %f" (dired-directory
				  dired-directory
				  (revert-buffer-function " %b"
							  ("%b - Dir:  " default-directory)))))))

(setq load-path (append load-path (list "~/env/elisp" "~/env"
					"~/.emacs.d/elisp"
					"~/.emacs.d/org/lisp/org-mode/lisp"
					"~/.emacs.d/org/lisp/org-mode/contrib/lisp"
					(expand-file-name "~/vm/lisp")
					"~/.emacs.d/ensime/elisp"
                                        "~/.emacs.d/elpa"
					)))

(package-initialize)

(setq exec-path (append exec-path (list "/usr/local/bin" "/Users/barshirtcliff/bin")))


(add-to-list 'Info-default-directory-list
	     (expand-file-name "~/env/info"))
;; ;; ------------------------------------------------------------------------
;; ;; Mode Customizations / Hooks
;; ;; ------------------------------------------------------------------------


(require 'bar-elisp)

;; (setq-default ispell-program-name "aspell")

;; miscellany
(add-hook 'isearch-mode-end-hook 'my-goto-match-beginning)


;; text-mode
(setq default-major-mode 'text-mode)
(add-hook 'text-mode-hook
	  '(lambda () (auto-fill-mode 1)))
(add-hook 'text-mode-hook
	  '(lambda () (abbrev-mode 1)))
(add-hook 'erc-mode-hook
	  '(lambda () (abbrev-mode 1)))
(add-hook 'scala-mode-hook
	  '(lambda () (abbrev-mode 1)))
(add-hook 'text-mode-hook
	  '(lambda () (winner-mode 1)))
(add-hook 'emacs-lisp-mode-hook
	  '(lambda () (winner-mode 1)))

;; org-mode
;; (setq org-mode-abbrev-table text-mode-abbrev-table)
(setq erc-mode-abbrev-table text-mode-abbrev-table)
(setq erc-server-send-ping-interval nil)
        
 (add-hook 'java-mode-hook (lambda ()
                                (setq indent-tabs-mode nil)))


;; ------------------------------------------------------------------------
;; Emacs options
;; ------------------------------------------------------------------------
(setq x-select-enable-clipboard t)
(desktop-save-mode 1)
(setq enable-recursive-minibuffers t)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(load-theme 'misterioso)

(defalias 'yes-or-no-p 'y-or-n-p)
(display-time-mode 1)
(defun sm-try-smerge ()
  (save-excursion
    (goto-char (point-min))
    (when (re-search-forward "^<<<<<<< " nil t)
      (smerge-mode 1))))

(add-hook 'find-file-hook 'sm-try-smerge t)
(desktop-save-mode 1)

;; ;; ------------------------------------------------------------------------
(require 'bar-edit)
(require 'bar-nav)
(require 'bar-menus)
(require 'bar-convenience)
(require 'bar-frames)
(require 'bar-yank)
(require 'bar-mac)
;; (require 'iedit)

;; (require 'flyspell)
(require 'light-symbol)
;; (require 'cc-mode)
;; (require 'org-babel-init)
;; (require 'org-babel-python)
;; (org-babel-load-library-of-babel)
;; (require 'sig-quote)
(require 'uniquify)
(require 'ensime)
(require 'recentf)


(defun me-turn-off-indent-tabs-mode ()
  (setq indent-tabs-mode nil))
(add-hook 'scala-mode-hook 'me-turn-off-indent-tabs-mode)
(setq case-fold-search nil)
;; (require 'vm-autoloads)
;; (load-file "~/vm/vm-load.el")
(server-start)

(require 'ime-ffip)
(put 'narrow-to-page 'disabled nil)

(show-paren-mode)
(require 'midnight)
(put 'narrow-to-region 'disabled nil)
(setq indent-tabs-mode nil)

;; ----------------------------------------------------------------------
;; Babel-mode
;; ----------------------------------------------------------------------

;; active Babel languages
(org-babel-do-load-languages
 'org-babel-load-languages
 '((clojure . t)
;;   (emacs-lisp . nil)
   ))
;;(require 'scala-mode-auto)
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)
;; (remove-hook 'scala-mode-hook 'ensime-scala-mode-hook)
(require 'erc-customize)
(setq ido-default-buffer-method 'selected-window)
(eval-after-load "find-file-in-project"
  '(progn (add-to-list 'ffip-patterns "*.scala")
          (add-to-list 'ffip-patterns "*.xml")
          (add-to-list 'ffip-patterns "*.java")
          (add-to-list 'ffip-patterns "*.rb")
          (setq ffip-find-options "-not -path '*/target/*'")))
(require 'expand-region)
(require 'ime-ffip)
(require 'yasnippet)
(require 'auto-yasnippet)
(require 'bar-abbrevs)

;;(yas-global-mode 1)
(setq make-backup-files nil) 
;; (add-hook 'find-file-hook 'enable-test-case-mode-if-test)
(setq-default indent-tabs-mode nil)
(setq bookmark-default-file "~/.emacs.d/Bookmarks.el")

(desktop-read)
