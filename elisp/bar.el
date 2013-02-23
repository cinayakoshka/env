;;-----------------------------------------------------------------------------
;; bar.el - mirror menu
;;-----------------------------------------------------------------------------

(defconst mirror-head-dir "~/Sites/")

(defun mirror-file (dir)
  "Defined in ~/env/emacs/my-elisp/my-menus.el.
Find mirroring file in other window, for dir given.
Courtesy of Bar Shirtcliff. Her comment:
This is the dumb program that does the hard labor, around here.
It's proud to save my friend, Emily Dickinson, minutes, every day."
  (string-match (concat mirror-head-dir "/") buffer-file-name)
  (let* ((this-address (substring buffer-file-name (match-end 0)))
		 (foo (string-match "/" this-address))
		 (new-address (concat mirror-head-dir "/" dir (substring 
													   this-address foo))))
	(find-file-other-window new-address)
	))

(defun my-mirror-menu()
  "Defined in ~/elisp/bar.el."

  (interactive)     
  (let*   (        (choices   '(   
								"pilm"
								"smt"
			))

		 (ltrs '(
				 "p" 
				 "s"
				 ))

		 (choice (my-choose choices ltrs))
		 )
	(cond
	 ( (string-equal choice "3") (progn (mirror-file "pilm")))
	 ( (string-equal choice "s") (progn (mirror-file "smt")))
	 (t ()))
	))
