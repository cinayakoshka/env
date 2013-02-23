;; many of these are not strictly mine.

(defun py-narrow-to-class nil
  (interactive)
  (save-excursion
    (py-beginning-of-def-or-class t)
    (let
        ((start (point)))
      (py-end-of-def-or-class t)
      (narrow-to-region (point) start))))


(defvar  my-fixable-chars "aAbBcGdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTuUvVwWxXyYzZ")

(defun my-delete-last (s)
  (save-excursion
	(setq case-fold-search nil)
	(re-search-backward s)
	(delete-char 1)
	)
  )

(defun my-fix-last (s)
  (let ((n (string-match s my-fixable-chars)))
	(save-excursion
	  (if (zerop (% n 2))
		  (setq ns (make-string 1 (aref my-fixable-chars (+ 1 n))))
		(setq ns (make-string 1 (aref my-fixable-chars (1- n)))))
	  (setq case-fold-search nil)
	  (re-search-backward s)
	  (replace-match ns t))))

(defvar my-fix-last-history nil "used in my-replace-last")
(defvar my-fixed-last-history nil "used in my-replace-last")

(defun my-replace-last ()
(interactive)
(save-excursion
 (let ((s (read-string "old string or char: " nil 'my-fixed-last-history))
	   (ns (read-string "new string or char: " nil 'my-fix-last-history)))
   (setq start (point))
 	  (setq case-fold-search nil)
	  (re-search-backward s)
	  (replace-match ns t)
	  (goto-char start))))

(defun my-buffers-menu-write-file(filename)
  (interactive "fWrite file: ")
  (write-file filename))

(defun my-upcase-backwards ()
  (interactive)
(save-excursion
  (setq place (point))
  (backward-word 1)
  (while (looking-at "[^a-z]+")
	(backward-word 1))
  (upcase-initials-region (point) (+ 2 (point)))))

(defun delete-rest-of-buffer ()
  "clear the contents of the buffer forward from point."
  (interactive)
  (delete-region (point) (point-max)))

(defun my-ispell-word-backwards (&optional arg)
  (interactive "P")
  (let ((start (point)))
    (backward-word (if arg arg 1))
    (re-search-backward "\\w" nil t)
    (ispell-word)
    (goto-char start)
    ))

(defun my-upcase-region()
  "Defined in: ~/emacs/my-elisp/my-misc.el.
My upcase-region function, done the way it was in the old days."
  (interactive)
  (upcase-region (point) (mark))
  )

(defun my-downcase-region()
  "Defined in: ~/emacs/my-elisp/my-misc.el.
My upcase-region function, done the way it was in the old days."
  (interactive)
  (downcase-region (point) (mark))
  )

(defun pipe-to-end ()
  (interactive)
  (replace-regexp "^" "| "))
 
 
(defun quote-to-end ()
  (interactive)
  (let
      ((start))
    (beginning-of-line)
    (delete-horizontal-space)
    (setq start (point))
 
    (while
		(= 0 (forward-line 1))
      (delete-horizontal-space))
 
    (goto-char start)
 
    (while
		(not (= (point) (point-max)))
      (fill-paragraph nil)
      (forward-paragraph))
 
    (goto-char start)
    (pipe-to-end)
 
    (goto-char (point-max))
    (beginning-of-line)
 
    (while
		(looking-at "^|[ ]*$")
      (kill-line)
      (forward-line -1))
 
    (goto-char start)))
 
(defun underline-line (&optional ch)
  (interactive "p")
  (cond
   ((= ch 4)							; We simply got a C-u arg, so prompt.
    (setq ch
		  (string-to-char
		   (read-from-minibuffer "Underline using which char? "))))
   ((= ch 1)
    (setq ch ?-)))
  
  (save-excursion
    (let (beg count)
      (beginning-of-line)
      (setq beg (point))
      (end-of-line)
      (setq count (- (point) beg))
      (insert "\n")
      (insert-char ch count))))

(defun kill-white-after (&optional newlines-are-white)
  (interactive "P")
  (let
      ((what-to-eat (if newlines-are-white " \\|\t\\|\n" " \\|\t")))
    (while (looking-at what-to-eat)
      (delete-char 1))))

(provide 'bar-edit)