;; functions for composition
(defvar my-outline-doc-start-regexp "begin{document}"
  "*for my-outline-random-select.")
(defvar my-outline-unwritten-item-regexp "% +\\*"
  "*for my-outline-random-select.")
(defvar my-outline-written-item-string "%% "
  "*for my-outline-random-select.")


;; (defun my-outline-random-select (&optional arg)
;; "Choose a random line in an outline, to write (or contemplate!).
;; Will rewrite the current outline item according to MY-OUTLINE-WRITTEN-ITEM-STRING if the last command was my-outline-random-select.  Prefix argument reverses that behavior."
;;   (interactive "P")
;;   (if (xor (list arg (eql (car (car (cdr command-history))) 'my-outline-random-select)))
;;       (progn
;;         (re-search-backward my-outline-unwritten-item-regexp nil t)
;;         (replace-match my-outline-written-item-string)))
;;   (let ((count 0)
;;         (randint 0))
;;     (goto-char (point-min))
;;     (re-search-forward my-outline-doc-start-regexp nil t)
;;     (while
;;         (re-search-forward my-outline-unwritten-item-regexp nil t)
;;       (setq count (+ 1 count)))
;;     (setq randint (random count))
;;     (goto-char (point-min))
;;     (re-search-forward my-outline-unwritten-item-regexp nil nil randint)
;;     ))

;; (defun xor (operands)
;;   "Returns a nil or t value for bitwise exclusive or of listed operands.
;; operands can be numbers or anything that evaluates to nil or t."n
;;   (interactive)
;;   (if (eq 0
;;   (apply 'logxor
;;    (mapcar (lambda (x) (if (numberp x) x (bool-to-int x))) operands)))
;;       nil
;;     t))

;; (defun bool-to-int (bool)
;;   "Converts nil to 0, everything else to 1."
;;   (if (not bool)
;;       0
;;     1))

(defun add-list-of-names-to-blank-table ()
  "This works in org mode.  It should probably be modified for a
  better mode for tables."
  (interactive)
  (setq target (point))
  (while (re-search-forward "\\w" nil t)
    (beginning-of-line)
    (kill-word 1)
    (goto-char target)
    (yank)
    (re-search-forward "\\w" nil t)
    (beginning-of-line)
    (kill-word 1)
    (goto-char target)
    (org-cycle)
    (yank)
    (org-return)
    (beginning-of-line)
    (org-cycle)
    (setq target (point))))

(defun translate (text &optional arg)
  "Translates from Russian to english using dictionary.com.
Keeps a record of all of your translations in a buffer called 'my translations'."
  (interactive 
   (let ((text (read-string "text: " nil nil))
         (arg current-prefix-arg))
     (list text arg)))
  (let* ((coding-system-for-write 'utf-8)
        (coding-system-for-read 'utf-8)
        (tran-dir (if arg
                   (read-string
                    (format "From which language to which (default %s): " secondary-tran-dir)
                    nil nil secondary-tran-dir nil)
                 default-tran-dir)))
    (setq translation-count (1+ translation-count))
    (shell-command (format "tran %s '%s'" tran-dir text) "my last translation")
    (save-excursion
      (set-buffer "my last translation")
      (copy-region-as-kill (point-min) (point-max)))
    (kill-buffer "my last translation")
    (let* ((co (first kill-ring))
          (lbreak (string-match "\'  \'" co 1))
          (orig (substring-no-properties co 0 (1+ lbreak)))
          (translated (substring-no-properties co (+ 3 lbreak))))
      (set-buffer (get-buffer-create "my translations"))
      (if (eql (point-min) (point-max))
          (insert
           (propertize
            (format "%-55s%s\n" "Original text" "Translation")
            'face '(:foreground "#7b68ee" :underline t))
           )
        )
      (goto-char (point-max))
      (insert (propertize (format "%-55s%s" orig translated) 'face
                          (if (oddp translation-count)
                              '(:foreground "PaleGreen1")
                            '(:foreground "DarkSlateGray1"))))
      )
    )
  )


(defvar my-quote-however-copy-history ())

(defun my-quote-however-copy (&optional arg)
  (interactive)
  (let ((prefix
         (if arg
             (read-string "prefix: " nil my-quote-however-copy-history
                          (or (car my-quote-however-copy-history) nil))
           "|")))
    (save-excursion
      (set-buffer (get-buffer-create "*quote-temp*"))
      (yank)
      (goto-char (point-min))
      (replace-regexp "^" prefix)
      (kill-region (point-min) (point-max)))
    (kill-buffer  "*quote-temp*")))

(defun my-pipe-quote-copy ()
  (interactive)
  (my-quote-however-copy nil))

(defun my-no-newlines-copy ()
  (interactive)
    (save-excursion
      (set-buffer (get-buffer-create "*quote-temp*"))
      (yank)
      (goto-char (point-min))
      (replace-regexp "[\n]" "")
      (kill-region (point-min) (point-max)))
    (kill-buffer  "*quote-temp*"))

(defun catch-url (&optional arg)
  "locate the nth (default first) url in the message and store it in the kill-ring.
useful for elephants."
  (interactive "p")
  (or arg (setq arg 1))

  (save-excursion
	(other-window 1 nil)
	(goto-char (point-min))
	(let ((count 0))

	  (if
		  (not
		   (while
			   (and (< (point) (point-max))
					(< count arg)
					(re-search-forward "http" nil t))
			 (setq count (1+ count))))

		  (progn (backward-char 4)
				 (let ((beg (point))
					   (end
						(progn
						  (re-search-forward "[ $\t\n]+" nil t)
						  (backward-word 1)
						  (forward-word 1)
						  (while
							  (save-excursion
								(progn
								  (backward-char 1)
								  (looking-at "[].?!\"')} ]")))
							(backward-char 1))
						  (point))))
				   (clipboard-kill-ring-save beg end)
				   (message "url copied.")
				   (message "url %d copied." count)))

		(message "no urls in this mail message."))

	  (other-window 1 nil)
	  )))


 (car kill-ring))))

(defun count-words-in-region (beg end)
  "word counter.  calls recursive function."
  (interactive "r")
  (save-excursion (goto-char beg)
				  (let ((count (count-words-in-region-recursively end)))
					(cond ((zerop count)
						   (message "the region has no words."))
						  ((= 1 count)
						   (message "the region has one word."))
						  (t
						   (message "the region has %d words." count))))))

(defun check-vm-mail ()
  (interactive)
  (save-excursion
	(set-buffer "INBOX Summary")
	(vm-get-new-mail)))

(defvar my-twitter-ident '("barshirtcliff" . "rosebuds")
  "*Username and password at Twitter.")

(defun translate (text)
  "Translates from ussian to english using dictionary.com"
  (interactive "Mtext: ")
  (setq coding-system-for-write 'utf-8
        coding-system-for-read 'utf-8)
  (shell-command (format "tran '%s'" text))
  )

(defun twit (mesg)
  (interactive "MTwit: ")
  (call-process "twit"
   nil 0 nil 
    (car my-twitter-ident) (cdr my-twitter-ident) mesg))


(defun twitter-get-my-timeline ()
  (interactive)
  (set-buffer (get-buffer-create "*my twitter timeline*"))
  (erase-buffer)
  (get-timeline (car my-twitter-ident)))


(defun get-timeline (person)
  (interactive)
  (if (eql person (car my-twitter-ident))
      (setq bufname "*my twitter timeline*")
    (setq bufname (format "*%s's twitter timeline*" person)))
  (set-buffer (get-buffer-create bufname))
  (erase-buffer)
  (call-process "twitgettimeline" 
   nil t '(bufname "twitter.errors"); (real-buffer stderr-file) 
    (car my-twitter-ident) (cdr my-twitter-ident) person))

(defun odd (arg)
  "Defined in ~/emacs/my-elisp/my-misc.el.  True if arg is odd."
  (eq (% arg 2) 1))

(provide 'bars-old-hacks)