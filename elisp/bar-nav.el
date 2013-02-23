;; I did not write these.

(defun my-goto-match-beginning ()
  (when isearch-forward (goto-char isearch-other-end)))

(defun my-bookmark-load-current-buffer()
  "Defined in: ~/emacs/my-menus.el. Bookmark-load current buffer."
  (interactive)
  (setq bookmark-alist nil)
  (bookmark-load (buffer-name))
  )


(defun my-get-bookmark-name (op)
  (interactive) 
  (let 
	  ((str (completing-read
			 (concat op " bookmark : ")
			 bookmark-alist nil 0)))
	str))

(defun my-buffers-previous-buffer ()
  (interactive)
  (switch-to-buffer-other-window (other-buffer)))

(defun my-point-jump()
  "Defined in ~/emacs/elisp/my-menus.el
Jump to point location stored in register."
  (interactive)
  (let* ( (register (read-from-minibuffer 
										  "Jump to point stored in register: "))
		  )
	(message (concat "jump to point stored in reg " register))
	(register-to-point (string-to-char register))))

(defun my-point-store()
  "Defined in ~/emacs/elisp/my-menus.el."
  (interactive)
  (let* ( (register (read-from-minibuffer "Store point in reg: "))
		  )
	(point-to-register (string-to-char register))
	(message (concat "stored point in reg " register))))



(defun my-tags-apropos ()
  "Defined in ~/emacs/elisp/my-menus.el.  
Get regexp from user, then pass to tags-apropos function."
  (interactive)(let* ( (regexp (read-from-minibuffer  "regexp: ")))
				 (tags-apropos regexp)))


(defun my-tags-search ()
  "Defined in ~/emacs/elisp/my-menus.el.  
Get regexp from user, then pass to tags-search function."
  (interactive)(let* ( (regexp (read-from-minibuffer  "regexp: ")))
				 (tags-search regexp)))


(defun end-of-next-line ()
  (interactive)
  (next-line 1)
  (end-of-line))

(provide 'bar-nav)