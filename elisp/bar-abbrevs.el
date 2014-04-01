;; bar's reminders and convenience stuff for abbrevs, take two.

(setq dabbrev-case-replace nil)

;; ----------------------------------------------------------------------
;; monitor-abbrev-mode.
;; ----------------------------------------------------------------------
(require 'thingatpt)

(defun abbrev-for (word)
  "See if a word has an abbrev defined.
If it does, return the first one.  Otherwise, nil."
  (let (
   (tables (list (symbol-name (abbrev-table-name local-abbrev-table))
		 (symbol-name (abbrev-table-name global-abbrev-table))
		 (symbol-name (abbrev-table-name text-mode-abbrev-table))))
   )
    (car (mapcar '(lambda (table) (abbrev-for-in-table word table)) tables))))

(defun abbrev-for-in-table(word table)
  (let (
         (res (shell-command-to-string
            (format "%s -d \" ))\" \"'%s\" %s | grep  '\"%s\"'" 
            (expand-file-name "~/bin/agrep")
            (car (split-string table "-abbrev-table"))
             (expand-file-name abbrev-file-name)
             word)))
         )
    (if (or (not res)
            (not (string-prefix-p "    (" res)))
        nil
      (car (cdr (delete " " 
             (split-string res "\"" 
			   split-string-default-separators)))))
    )
  )
	

(defun check-word ()
  (let ((word (thing-at-point 'word)))
    (if (abbrev-symbol word)
        (abbrev--default-expand)
      (let ((abbrev (abbrev-for word)))
        (if abbrev
            (message "%s -> %s" abbrev word))))))

(defun check-my-abbrevs() (interactive)
       (setq abbrev-expand-function 'check-word))

;; ----------------------------------------------------------------------
;; not related to monitor-abbrev.  this is juts convenience.
;; ----------------------------------------------------------------------

(defun my-abbrev-checker ()
 "Checks for the existence of an abbrev and offers to define it locally."
 (interactive)
 (save-excursion
  (let* ((wrd (buffer-substring-no-properties (point) (save-excursion (forward-word -1) (point))))
         (abb (abbrev-for wrd)))
    (if abb 
      (message (format "%s" abb))
      (let ((lcl (abbrev-table-name local-abbrev-table)))
       (if (y-or-n-p-with-timeout 
            (format "no abbrev found for \"%s\" in %s.  define locally? " wrd lcl) 5 nil)
	 (progn
	  (setq abbr (read-from-minibuffer (format "%s abbrev for %s: " lcl wrd)))
	  (if (abbrev-expansion abbr local-abbrev-table)
            (if (y-or-n-p (format "%s expands to \"%s\"; redefine? " abbr 
                                  (abbrev-expansion abbr local-abbrev-table)))
		(define-abbrev local-abbrev-table abbr wrd))
	    (define-abbrev local-abbrev-table abbr wrd))))) )) ))

(provide 'bar-abbrevs)

;; use abbrevs in scala comments:
;; change char-after below to matching "//" earlier in the line.
;; (defun scala-mode-abbrev-expand-function (expand)
;;   (if (not (save-excursion (forward-line 0) (eq (char-after) ?#)))
;;       ;; Performs normal expansion.
;;       (funcall expand)
;;     ;; We're inside a comment: use the text-mode abbrevs.
;;     (let ((local-abbrev-table text-mode-abbrev-table))
;;       (funcall expand))))

;; (add-hook 'scala-mode-hook
;;           #'(lambda ()
;;               (add-hook 'abbrev-expand-functions
;;                         'scala-mode-abbrev-expand-function
;;                         nil t)))

;; non-shell version in case agrep gets lost
;; ;; returns the abbrev if the word has one.
;; ;; first abbrev found if multiple..
;; (defun abbrev-for (wrd)
;;  (let ((checks nil))
;;   (mapatoms 
;;    (lambda (abb) (let ((ab (symbol-name abb)))
;;      (if (expands-to ab wrd) (push ab checks)))))
;;   (if checks
;;       (car checks)
;;       nil)))


;; ;; returns true if the abbrev expands to the word.
;; (defun expands-to (ab wrd) 
;;   (string= wrd 
;;    (abbrev-expansion ab local-abbrev-table)))
