;; so I did this wrong, to begin w.  when I wrote it, I shd hv
;; overriddn the usual call to expand-abbrev, so that successfully
;; expanded abbrevs won't trigger looking into the definitions.  also
;; the search for the word in question should be a pure shell call.



;; use this to see if it's defined as an abbrev.
(abbrev-symbol "and")


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

(provide 'bar-abbrevz)


; total amount owed at more than 5%:
(+ 2870.42 8253.53 8763.52 5198.47 7217.02) 32302.960000000003

