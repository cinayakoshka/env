(defun yank-by-regexp2 (regexp)
  "Yanks an element from the kill-ring distinguished by a regexp.
Fails if multiple matches, or if the ring is empty."
  (interactive "sEnter regexp: ")
  (if  kill-ring


	  (save-excursion
		(let ((n 0)
			  (l ())
			  (old-buf (current-buffer))
			  (count 0))
		  (setq insertion-point (point))
		  (set-buffer (get-buffer-create "*temp*"))

		  (while (and (< n (length kill-ring))
					  (< count 2))
			(erase-buffer)
			(print (car (nthcdr n kill-ring)) (current-buffer))
			(goto-char (point-min))
			(if (re-search-forward regexp nil t)
				(progn (setq l n)
					   (setq count (1+ count))
					   (setq n (1+ n)))
			  (setq n (1+ n))))

		  (cond ((> count 1)
				 (message "There are multiple matches in the kill-ring.  Try another regexp."))
				((= count 0)
				 (message "The regexp does not exist in the kill-ring.  Try another."))
				((= count 1)
				 (set-buffer old-buf)
				 (goto-char insertion-point)
				 (insert (car (nthcdr l kill-ring)))))
		  (kill-buffer "*temp*")))


	(message "The kill ring is empty.")))

(defun yank-by-regexp (regexp)
  "Same as yank-by-regexp, but allows you to just yank the last occurrence, if there is one."
  (interactive "senter regexp: ")
  (let ((result ()) (n 0))
	(while (and (< n (length kill-ring)) (not result))
	  (setq string (car (nthcdr n kill-ring)))
	  (if (string-match regexp string)
		  (setq result string)
		(setq n (1+ n))))
	(if result (insert string)
	  (message "failed to find \"%s\" in the kill-ring." regexp))))
(provide 'bar-yank)
