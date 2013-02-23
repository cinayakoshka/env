;; I'm not sure if these are mine.

(defun my-load-current-file()
  "Defined in: ~/emacs/my-menus.el. Load current buffer"
  (interactive)
  (save-buffer buffer-file-name)
  (load-file buffer-file-name)
  )

(defun my-byte-compile-current-file()
  "Defined in: ~/emacs/my-menus.el. 
Byte-compile elisp in current buffer, saving it first."
  (interactive)
  (save-buffer buffer-file-name)
  (byte-compile-file buffer-file-name)
  )


(defun eval-line ()
  (interactive)
  (beginning-of-line)
  (forward-sexp)
  (eval-last-sexp nil))

(provide 'bar-elisp)