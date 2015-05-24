(defun json-pprint-1 (start end)
  (shell-command-on-region start end "python -mjson.tool" nil t)
  (delete-trailing-whitespace (point) (mark)))
 
(defun json-pprint ()
  (interactive)
  (let ((start (if (region-active-p) (region-beginning) (point-min)))
        (end   (if (region-active-p) (region-end) (point-max))))
    (json-pprint-1 start end)))
 
(defun json-pprint-sexp ()
  (interactive)
  (let ((start (point)))
    (json-pprint-1 start (save-excursion (forward-sexp) (point)))))

(provide 'json-pprint)
