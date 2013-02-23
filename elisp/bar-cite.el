;; bar-cite mode and related functions
(defvar bar-cite-citation-letters '(a b c d e f g h i j k l m n o p q r s t u v w x y z))
(defvar bar-cite-citation-hash (make-hash-table :size 26 :test 'equal)
  "Table in which citations are held")
(defvar bar-cite-citation-format "\\footnote{\\citealt*[%s.]{%s}}")
(defvar bar-cite-bib-apropos-history ())

(defun bar-cite-bib-apropos ()
  "Display a poppy-menu offering one the results of a bib-apropos
type search as selections, the chosen of which will be passed to
the usual citation functions.  Most of this code is borrowed from
bib-apropos, from bib-cite.el."
  (interactive)
  (let* ((keylist (and (boundp 'TeX-auto-update) ;Avoid error in FRAMEPOP
		       (fboundp 'LaTeX-bibitem-list) ;Use this if using auctex
		       (LaTeX-bibitem-list)))
	 (keyword (bib-apropos-keyword-at-point))
	 (keyword (completing-read "BiBTeX apropos: " keylist nil nil keyword))
	 (the-text)(key-point)(start-point)
	 (new-buffer-f (and (not (string-match "^bib" mode-name))
			    (not (string-equal "*Help*" (buffer-name)))))
	 (bib-buffer (or (and new-buffer-f (bib-get-bibliography nil))
			 (current-buffer))))
    (let ((hash (make-hash-table :size 26 :test 'equal))
          (bar-cite-bib-apropos-letters '(a b c d e f g h i j k l m n o p q r s t u v w x y z)))
      (save-excursion
        (set-buffer bib-buffer)
        (goto-char (point-min))
        (setq success nil)
        (while (and (re-search-forward "^[ \t]*@" nil t)
                    (re-search-forward keyword nil t))
          (re-search-backward "^[ \t]*@" nil t)
          (re-search-forward "{" nil t)
          (setq start-point (point))
          (end-of-line)
          (re-search-backward ",")
          (puthash (buffer-substring-no-properties start-point (point)) (car bar-cite-bib-apropos-letters) hash)
          (setq bar-cite-bib-apropos-letters (cdr bar-cite-bib-apropos-letters))
          (setq success t)))
      (if (not success)
          (message "Sorry, no matches found.")
        (bar-cite-bib-apropos-menu hash)))))


(defun bar-cite-insert-repeat-citation (source page)
  "Inserts a citation formatted according to the format described
in bar-cite-citation-format."
    (insert (format bar-cite-citation-format page source)))


(defun bar-cite-insert-new-citation (&optional citation)
  "Inserts a new citation at point, formatted according to
bar-cite-citation-format, and adds the citation key to the
repeat-citation menu.  Be careful--the page number will take any
string argument, to accomodate ranges."
  (interactive)
  (let* ((page (read-string "page(s) to cite: "))
         (new (or citation (read-string "citation: "))))
    (insert (format bar-cite-citation-format page new))
    (bar-cite-add-new-citation-to-hash new)))



(defun bar-cite-add-new-citation-to-hash (new)
  "Adds a new citation to bar-cite-citation-hash, with either its
own first letter, as a selection choice, or the next letter in
bar-cite-citation-letters."
  (if bar-cite-citation-letters
      (if (not (gethash new bar-cite-citation-hash))
          (progn
            (let ((ltr (or (assoc-string (downcase (format "%c" (elt new 0))) bar-cite-citation-letters)
                           (car bar-cite-citation-letters))))
              (puthash new ltr bar-cite-citation-hash)
              (setq bar-cite-citation-letters
                    (mapcar '(lambda (char) (if (string= char ltr)
                                                nil
                                              char))
                            bar-cite-citation-letters))))
        (message (format "%s has already been put on the menu." new)))
    (message "uh-oh, better clear that citation hash and fix this program.  You've cited more than 26 texts.")))



(defun bar-cite-bib-apropos-menu (hash)
  "This menu need not be mapped to any particular key.
Defined only at the moment of use."
  (interactive)

  (setq choices ()
        ltrs ())

  (maphash
   (lambda (key value)
     (progn
       (setq choices (cons key choices)
             ltrs (cons (format "%s" value) ltrs))))
   hash)

  (let ((choice (my-choose choices ltrs)))

    (maphash
     '(lambda (key value)
        (cond (
               (string-equal choice value)
               (bar-cite-insert-new-citation key)))
        )
     hash))
  )


(defun bar-cite-citation-menu ()
  "Poppy buffer created on call, holding up to 26 sources for
quick, poppy citation.  Citations must be entered via
bar-cite-insert-new-citation."
  (interactive)
  (if bar-cite-citation-hash

      (progn
        (setq choices ()
              ltrs ())

        (maphash
         (lambda (key value)
           (progn
             (setq choices (cons key choices)
                   ltrs (cons (format "%s" value) ltrs))))
         bar-cite-citation-hash)

        (let ((choice (my-choose choices ltrs)))

          (maphash
           '(lambda (key value)
              (cond (
                     (string-equal choice value)
                     (bar-cite-insert-repeat-citation key (read-string "page number: "))))
              )
           bar-cite-citation-hash)))

    (message "you have made no citations this emacs session.")))


(defvar bar-cite-mode-menu 
  (let ((map (make-keymap)))

    (define-keys map
      (list
      "\C-cq"  'bar-cite-mode
      "\C-cn"  'bar-cite-insert-new-citation
      "\C-cr"  'bar-cite-citation-menu
      "\C-ca"  'bar-cite-bib-apropos))

    (define-key map [menu-bar cite]
      (cons "cite" (make-sparse-keymap "cite")))

    (define-key map [menu-bar cite bar-cite-insert-new-citation]
      '(menu-item "new citation" bar-cite-insert-new-citation
                  :help "foo."))
    (define-key map [menu-bar cite bar-cite-citation-menu]
      '(menu-item "repeat citation" bar-cite-citation-menu
                  :help "foo."))
    (define-key map [menu-bar cite quit]
      '(menu-item "quit bar-cite mode" bar-cite-mode
                  :help "foo."))
    
    (define-key map [menu-bar cite foo]
      (cons "foo" (make-sparse-keymap "foo")))

  map)
  "Mode map for bar-cite-mode.")

(define-minor-mode bar-cite-mode "bar's cite mode"
  :keymap bar-cite-mode-menu
  :lighter " bar-cite "
  :group bar-cite
  (run-mode-hooks 'bar-cite-mode-hooks))

;; other stuff

(defvar translation-count 0)
(defvar default-tran-dir "ru_en"
  "*translation direction for fuction TRANSLATE.")
(defvar secondary-tran-dir "en_fr"
  "*translation direction for fuction TRANSLATE.")
