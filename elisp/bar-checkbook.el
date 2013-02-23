;; this is for my org-mode checkbook.
(defun bank-balance (prev-bank-balance item-value checked)
  (interactive)
  (if (not (string-equal checked ""))
  (format "%.2f" (- (string-to-number prev-bank-balance) (string-to-number item-value)))
   prev-bank-balance))

(provide 'bar-checkbook)

(defvar ZEROED-ACCOUNTS '("Discover Account") "Accounts that I zero every month in my checkbook.")

(defun checkbook-balance (last-balance last-payment)
  (interactive)
  (let ((owed 0)
        (mark (point)))
    (save-excursion
      (dolist (acct ZEROED-ACCOUNTS)
        (re-search-forward acct nil nil)
        (re-search-forward "^$" nil nil) ;; each table must end with a blank line.
        (previous-line 2) ;; but there is also a computation line.
        (beginning-of-line)
        (forward-char 1)
        (org-cycle)
        (org-cycle)
        (org-cycle)
        (org-cycle)
        (org-cycle)
        (org-cycle)
        (org-cycle)
        (setq owed (+ owed (string-to-number (get-value-in-this-box))))
        (goto-char mark))
      (format "%.2f" (+ (- last-balance last-payment) owed)))))

(defun get-value-in-this-box ()
  (setq r "-?[0-9]+")
  (re-search-forward "|")
  (re-search-backward r)
  (setq cat-start (+ 1 (point)))
  (re-search-backward "|")
  (re-search-forward r)
  (goto-char (match-beginning 0))
  (buffer-substring-no-properties cat-start (point)))

