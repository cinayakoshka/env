;; abbrev
(setq dabbrev-case-replace nil)

(defun my-abbrev-checker ()
  "Checks for the existence of an abbrev and offers to define it locally."
  (interactive)
  (save-excursion
    (let ((wrd (buffer-substring-no-properties (point) (save-excursion (forward-word -1) (point)))))
      (setq abb (catch 'foo
		  (sub-abcheck wrd)))
      (if abb (message (format "%s" abb))
	(let ((lcl (abbrev-table-name local-abbrev-table)))
	  (if (y-or-n-p-with-timeout (format "no abbrev found for \"%s\" in %s.  define locally? " wrd lcl) 5 nil)
	      (progn
		(setq abbr (read-from-minibuffer (format "%s abbrev for %s: " lcl wrd)))
		(if (abbrev-expansion abbr local-abbrev-table)
		    (if (y-or-n-p (format "%s expands to \"%s\"; redefine? " abbr (abbrev-expansion abbr local-abbrev-table)))
			(define-abbrev local-abbrev-table abbr wrd)
		      (minibuffer-message "okay."))
		  (define-abbrev local-abbrev-table abbr wrd))))) )) ))

;; this is horrible!!!
(defun sub-abcheck (wrd)
  "checks to see if word already has an abbrev defined.
Used within my-abbrev-checker.  Returns abbrev name or nil."
  (let ((slist nil))
    (mapatoms (function (lambda (sym) (setq slist (push (symbol-name sym)  slist)))) local-abbrev-table)
    (mapc
     '(lambda (s)
	(if (string= (abbrev-expansion s local-abbrev-table) wrd)
	    (throw 'foo s))) slist)
    nil))

;; minor-mode monitor-abbrev-mode

(defun check-word ()
  "Part of monitor-abbrev mode."
  (interactive)
  (let ((ab nil)
        (start (point))
        (word (car (flyspell-get-word nil)))) ;; this should actually
    ;; make a list of words
    ;; to check.  we might
    ;; have something that
    ;; expands to a xxx-xxx
    ;; pattern, or a LaTeX
    ;; markup item, etc.
    (save-excursion
      (if (not (abbrev-symbol word));; it should go past here for
          ;; just-now expanded abbrevs!  fix
          ;; me!
          (my-abbrev-check-word word)))))
;; (set-process-filter (my-abbrev-check-word) 'abbrev-grep-filter)

(defun my-abbrev-check-word (word)
  "Part of monitor-abbrev mode.
This function does the work of checking each word.  It is called by check-word."
  (async-shell-command 
   (shell-quote-argument
    (format "agrep -d \" ))\" \"'text-mode-abbrev-table\" %s | grep  '\"%s\"'" abbrev-file-name word))
   ))

(defun abbrev-grep-filter (proc string)
  (with-current-buffer (process-buffer proc)
    (insert string)
    ))



(add-hook 'monitor-abbrev-mode-hook
          'monitor-abbrevs)

(defun monitor-abbrevs ()
  (interactive)
  (add-hook
   'pre-abbrev-expand-hook
   'check-word t t)
  (get-buffer-create "*Missed Abbrevs*"))

(define-minor-mode  monitor-abbrev-mode "monitor abbrev mode"
  :lighter " mon-abbrev "
  :global nil
  :keymap '(
            ("\C-q" . '(lambda () (remove-hook 'pre-abbrev-expand-hook 'check-word t)))
	    (run-mode-hooks 'monitor-abbrev-mode-hooks)))


(provide 'bar-abbrevs)
