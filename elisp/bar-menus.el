
;; ------------------------------------------------------------------------
;; Menus & Keys
;; ------------------------------------------------------------------------

(defun my-get-index(vec str)
  "Defined in ~/emacs/elisp/my-menus.el.
Given a vector vec of strings, return the index of the one matching str."
  (let* ((cur 0)
		 (count 0)
		 (len (length vec))
		 (index -1)
		 )
	(while (< count len)
	  (setq cur (nth count vec))
	  (if (string-equal cur str)
		  (setq index count))
	  (setq count (1+ count))
	  )
	index
	)
  )

(defun my-choose (choices ltrs)
  "Defined in ~/emacs/elisp/my-menus.el
Display possible choices from list CHOICES, with corresponding letters
LTRS. Letter q is reserved for quit.
 Return chosen LTR if one is chosen, or first LTR if user hits space bar."
  (unwind-protect
	  (save-window-excursion
		(let ((count 0)
;;			  (len (length choices))
			  (line 3)
			  (words choices)
			  (window-min-height 2)
			  (default (car ltrs))
			  char num result)
		  (save-excursion
			(set-buffer (get-buffer-create "*Choose*")) (erase-buffer)
			(setq mode-line-format (concat "--  %b (Letter selects choice. Default is "                                           default
										   ")  --"))
			(while words
			  (if (<= (+ 7 (current-column) (length (car words)))
					  (window-width))
				  nil
				(insert "\n")
				(setq line (1+ line)))
			  (insert (nth count ltrs) " = ")
			  (insert  (car words) ";  ")
			  (setq words (cdr words)
					count (1+ count)))
			(if (= count 0) (insert "(none)")))
		  (my-overlay-window line)
		  (switch-to-buffer "*Choose*")
		  (select-window (next-window))


		  (while (eq t
					 (setq result
						   (progn
							 (message "select: ?  q(uit)  ")
							 (setq char (read-char))
							 ;;			     (setq num (- char ?0))
							 ;; convert char chosen into index into choices
							 (setq char (char-to-string char))
							 (setq num (my-get-index ltrs char))

							 (cond
							  (  (string-equal char "q")   nil)
							  (  (string-equal char " ")   default)

							  ((>= num 0)
							   ;;						(nth num choices))
							   (nth num ltrs))

							  ( (string-equal char "?")
							    (message (concat "select your choice, space for default (" default ")"))
							    (sit-for 3) t)
							  (t (ding) t))))))
		  result))
    (bury-buffer "*Choose*")
    ))

(defun my-overlay-window (height)
  "Defined in ~/emacs/elisp/my-menus.el
Create a (usually small) window with HEIGHT lines and avoid recentering."
  (save-excursion
(setq height height)
    (let ((oldot (save-excursion (beginning-of-line) (point)))
		  (top (save-excursion (move-to-window-line height) (point)))
		  newin)
      (if (< oldot top) (setq top oldot))
      (setq newin (split-window-vertically height))
      (set-window-start newin top))))

(defun my-menus-goto-line()
  (interactive)
  (goto-line (read-from-minibuffer "Line no: " nil nil t)))

(defun my-menus-goto-char()
  (interactive)
  (goto-char (read-from-minibuffer "Char no: " nil nil t)))

(defun my-replace-regexp-menu-interactive-replace()
  "Defined in: ~/emacs/elisp/my-menus.el.
Prompt and perform interactive regex replacements."
  (interactive)
  (let* ( (src (read-from-minibuffer "Interactive replace regexp: "))
		  (dest (read-from-minibuffer "Replace with regexp: "))
		  )
	(query-replace-regexp src dest)
	(message (concat "Interactive replaced regexp" src " with: " dest))
	))


(defun my-replace-regexp-menu-global-replace()
  "Defined in: ~/emacs/elisp/my-menus.el.
Prompt and perform global regex replacements."
  (interactive)
  (let* ( (src (read-from-minibuffer "Global replace regexp: "))
		  (dest (read-from-minibuffer "Replace with regexp: "))
		  )
	(replace-regexp src dest)
	(message (concat "Global replaced regexp" src " with: " dest))
	))

(defun my-regexp-func-menu-global-insert-white-space()
"Defined in my-menus.el. Inserts 3 spaces at beginning of lines, from point to end of buffer."
  (interactive)
(save-excursion
  (replace-regexp "^" "   ")
))

(defun my-regexp-func-menu-global-replace-caret ()
"Defined in my-menus.el. Replaces ^ with whatever you give when prompted"
  (interactive)
(save-excursion
  (replace-regexp "^"
	   (read-from-minibuffer "Replace ^ with regexp: "))
))

(defun my-regexp-func-menu-global-replace-dollar ()
"Defined in my-menus.el. Replaces end of line (dollar) with whatever you give when prompted"
  (interactive)
(save-excursion
  (replace-regexp "$"
	   (read-from-minibuffer "Replace $ with regexp: "))
  ))


(defun my-regexp-func-menu-global-remove-leading-white-space()
"Defined in my-menus.el.  Deletes all leading white space from point to end of buffer"
  (interactive)
   (save-excursion
     (replace-regexp "^[ \t]*" "")
))

(defun my-regexp-func-menu-global-remove-control-chars()
"Defined in my-menus.el.  Deletes all control chars."
  (interactive)
   (save-excursion
     (progn
     (replace-regexp "" "")
     (replace-regexp "" "")
     (replace-regexp "" "")
     (replace-regexp "" "")
)
))

(defun my-regexp-func-menu-global-remove-newline()
"Defined in my-menus.el.  Globally deletes all newlines from point to end of buffer"
  (interactive)
(save-excursion
  (replace-regexp "[\n]" "")
))

(defun my-replace-regexp-menu-interactive-remove-newline()
"Defined in my-menus.el.  Interactively deletes newlines from point to end of buffer"
  (interactive)
(save-excursion
  (query-replace-regexp "[\n]" "")
))

(defun my-regexp-func-menu-global-remove-trailing-white-space()
"Defined in my-menus.el.  Deletes all trailing white space from point to end of buffer"
  (interactive)
   (save-excursion
  (replace-regexp "[ \t]*$" "")
  ))

(defun my-replace-menu-interactive-replace-string()
  "Defined in: ~/emacs/elisp/my-menus.el.
Wrapper for query-replace function, called from my-replace-menu."
  (interactive)
  (let* ( (src (read-from-minibuffer "Interactive replace: "))
		  (dest (read-from-minibuffer "Replace with : "))
		  )
	(query-replace src dest)
	(message (concat "Interactive replaced " src " with: " dest))
	))


(defun my-replace-menu-global-replace-string()
  "Defined in: ~/emacs/elisp/my-menus.el.
Wrapper for replace-string function, called from my-replace-menu."
  (interactive)
  (let* ( (src (read-from-minibuffer "Global replace: "))
		  (dest (read-from-minibuffer "Replace with : "))
		  )
	(replace-string src dest)
	(message (concat "Global replaced " src " with: " dest))
	))

(defun define-keys (map defns)
  (interactive "P")
  (if defns
      (progn
		(define-key map (car defns) (car (cdr defns)))
		(define-keys map (cdr (cdr defns))))))

(defun global-set-keys (defns)
  (interactive "P")
  (if defns
      (progn
		(global-set-key (car defns) (car (cdr defns)))
		(global-set-keys (cdr (cdr defns))))))

(defun my-bookmark-menu()
  "Defined in ~/emacs/elisp/my-menus.el.
Puts up a menu of bookmark-related functions in the minibuffer, gets
the letter chosen, and performs various actions depending upon choice.
Note: q is reserved for quit."

  (interactive)
  (let* (
		 (choices
		  '(
			"bookmark-load-cur-buf"
			"delete"
			"edit"
			"insert"
			"jump"
			"rename"
			"set"
			))
		 (ltrs '(
				 "b"
				 "d"
				 "e"
				 "i"
				 "j"
				 "r"
				 "s"
				 ))
		 (choice (my-choose choices ltrs))
		 )
	(cond
	 ( (string-equal choice "b") (my-bookmark-load-current-buffer))
	 ( (string-equal choice "d") (bookmark-delete (my-get-bookmark-name "delete")))
	 ( (string-equal choice "e") (list-bookmarks))
	 ( (string-equal choice "i") (bookmark-insert (my-get-bookmark-name "insert")))
	 ( (string-equal choice "j") (bookmark-jump (my-get-bookmark-name "jump to")))
	 ( (string-equal choice "r") (bookmark-rename (my-get-bookmark-name "rename")))
	 ( (string-equal choice "s") (bookmark-set) )
	 (t ()))
	))


(defun my-buffers-menu()
  "Defined in ~/emacs/elisp/my-menus.el.
Puts up a menu of buffer-related commands in the minibuffer, gets the
letter chosen, and performs various actions depending upon choice."
  (interactive)
  (let* (
		 (choices
		  '(
			"back-to-last-buf"
			"buffer-indent"
			"region-indent"
			"kill-some-buffers"
			"save-some-buffers"
			))
		 (ltrs '(
				 "b"
				 "i"
				 "r"
				 "k"
				 "s"
				 ))
		 (choice (my-choose choices ltrs))
		 )
	(cond
	 ( (string-equal choice "b") (my-buffers-previous-buffer))
	 ( (string-equal choice "i") (my-indent-buffer))
	 ( (string-equal choice "r") (my-indent-region))
	 ( (string-equal choice "k") (kill-some-buffers))
	 ( (string-equal choice "s") (save-some-buffers))
		 (t ()))
	))

(defun my-elisp-menu()
  "Defined in my-menus.el.
Puts up a menu of elisp stuff in the minibuffer, gets the letter chosen, and
performs various elisp-related functions depending on choice."
  (interactive)
  (let* (
		 (choices
		  '(
			"aliases-load-for-vm"
			"compile-file"
			"dmacro-load-buffer"
			"eval-region"
			"fire-up-server"
			"iso-accents-mode"
			"kill-server-edit"
			"load-current-file"
			"macro-load-current-file"
			"output-file-reset"
			"reset-compile"
			"startup-file-reload"
			"eval-last-sexp"
			"visit-startup-file"
			))
		 (ltrs '(
				 "a"
				 "c"
				 "d"
				 "e"
				 "f"
				 "i"
				 "k"
				 "l"
				 "m"
				 "o"
				 "r"
				 "s"
				 "x"
				 "v"
				 ))
		 (choice (my-choose choices ltrs))
		 )
	(cond
	 ( (string-equal choice "a")  (load "my-vm-aliases"))
	 ( (string-equal choice "c")  (my-byte-compile-current-file))
	 ( (string-equal choice "d")  (dmacro-load-buffer))
	 ( (string-equal choice "e")  (eval-region (mark) (point)))
	 ( (string-equal choice "f")  (server-start))
	 ( (string-equal choice "i")  (iso-accents-mode))
	 ( (string-equal choice "k")  (server-edit))
	 ( (string-equal choice "l")  (my-load-current-file))
	 ( (string-equal choice "m")  (dmacro-load buffer-file-name))
	 ( (string-equal choice "o")  (my-reset-output-file ))
	 ( (string-equal choice "r")  (my-reset-compile-command))
	 ( (string-equal choice "s")  (load-file my-version-specific-el))
	 ( (string-equal choice "x")  (eval-last-sexp ()))
	 ( (string-equal choice "v")  (find-file my-version-specific-el))
	 (t ()))
	))

(defun my-macro-menu()
  "Defined in $myenv/emacs/elisp/my-menus.el."

  (interactive)
  (let* (
		 (choices
		  '(
			"call"
			"define start/end"
			"forever-apply"
			"name"
			"region-apply"
			))

		 (ltrs '(
				 "c"
				 "d"
				 "f"
				 "n"
				 "r"

				 ))

		 (choice (my-choose choices ltrs))
		 )
	(cond
	 ( (string-equal choice "c") (call-last-kbd-macro))
	 ( (string-equal choice "d") (my-start-or-end-kbd-macro))
	 ( (string-equal choice "f") (call-last-kbd-macro 0))
	 ( (string-equal choice "n") (name-last-kbd-macro))
	 ( (string-equal choice "r") (apply-macro-to-region-lines))
	 (t ()))
	))

(defun my-points-menu()
  "Defined in my-menus.el.
Puts up a menu of stuff related to points in the minibuffer, gets the
letter chosen, and performs various actions depending upon choice."

  (interactive)
  (let* (
		 (choices '(
					"jump"
					"set"
					))
		 (ltrs '(
				 "j"
				 "s"
				 ))
		 (choice (my-choose choices ltrs))
		 )
	(cond
	 ( (string-equal choice "j") (my-point-jump))
	 ( (string-equal choice "s") (my-point-store))
	 (t ()))
	))


(defun my-replace-menu()
  "Defined in ~/emacs/elisp/my-menus.el."
  (interactive)
  (let* (
		 (choices
		  '(
			"global replace"
			"interactive replace"
			"global replace regexp"
			"interactive replace regexp"
			"beginning of line global regexp replace"
			"control character global remove"
			"end of line global regexp replace"
			"leading white space global remove"
			"newline global remove"
			"trailing white space global remove"
			"white space insert global"
			))

		 (ltrs '(
				 "g"
				 "i"
				 "G"
				 "I"
				 "b"
				 "c"
				 "e"
				 "l"
				 "n"
				 "t"
				 "w"
				 ))

		 (choice (my-choose choices ltrs))
		 )
	(cond
	 ( (string-equal choice "g") (my-wrap-replace-menu-selection(my-replace-menu-global-replace-string)))
	 ( (string-equal choice "i") (my-wrap-replace-menu-selection(my-replace-menu-interactive-replace-string)))
	 ( (string-equal choice "G") (my-wrap-replace-menu-selection(my-replace-regexp-menu-global-replace)))
	 ( (string-equal choice "I") (my-wrap-replace-menu-selection(my-replace-regexp-menu-interactive-replace)))
	 ( (string-equal choice "b") (my-wrap-replace-menu-selection(my-regexp-func-menu-global-replace-caret)))
	 ( (string-equal choice "c") (my-wrap-replace-menu-selection(my-regexp-func-menu-global-remove-control-chars)))
	 ( (string-equal choice "e") (my-wrap-replace-menu-selection(my-regexp-func-menu-global-replace-dollar)))
	 ( (string-equal choice "l") (my-wrap-replace-menu-selection(my-regexp-func-menu-global-remove-leading-white-space)))
	 ( (string-equal choice "n") (my-wrap-replace-menu-selection(my-regexp-func-menu-global-remove-newline)))
	 ( (string-equal choice "t") (my-wrap-replace-menu-selection(my-regexp-func-menu-global-remove-trailing-white-space)))
	 ( (string-equal choice "w") (my-wrap-replace-menu-selection(my-regexp-func-menu-global-insert-white-space)))
	 (t ()))
	))

(defun my-tags-menu()
  "Defined in my-menus.el.
Puts up a menu in the minibuffer, gets the letter chosen, and
performs various tags-related functions depending on choice."
  (interactive)
  (let* (
		 (choices
		  '(
			"apropos"
			"display tags-file-name"
			"reset-tags-file"
			"search"
			))
		 (ltrs '(
				 "a"
				 "d"
				 "r"
				 "s"
				 ))
		 (choice (my-choose choices ltrs))
		 )
	(cond
	 ( (string-equal choice "a")  (my-tags-apropos))
	 ( (string-equal choice "d")  (describe-variable 'tags-file-name))
	 ( (string-equal choice "r")  (my-reset-tags-file-name))
	 ( (string-eQual choice "s")  (my-tags-search))
	 (t ()))
	))



(defun my-main-menu()
  "Defined in ~/emacs/elisp/my-menus.el."

  (interactive)
  (let* (
		 (choices
		  '(
			"buffers"
			"char-goto"
			"edebug-defun"
			"elisp"
			"goto-line"
			"citations"
			"jump"
			"kill buf"
			"macros"
			"points menu"
			"reset-compile-command"
			"text"
			"bookmarks"
			"EXIT"
			))

		 (ltrs '(
				 "b"
				 "c"
				 "d"
				 "e"
				 "g"
				 "i"
				 "j"
				 "k"
				 "m"
				 "p"
				 "r"
				 "t"
				 "z"
				 "x"
				 ))

		 (choice (my-choose choices ltrs))
		 )
	(cond
	 ( (string-equal choice "b") (my-buffers-menu))
	 ( (string-equal choice "c") (my-menus-goto-char))
	 ( (string-equal choice "d") (delete-other-windows))
	 ( (string-equal choice "e") (my-elisp-menu))
	 ( (string-equal choice "g") (my-menus-goto-line))
	 ( (string-equal choice "j") (bookmark-jump (my-get-bookmark-name "jump to")))
	 ( (string-equal choice "i") (bar-cite-citation-menu))
	 ( (string-equal choice "k") (kill-buffer nil))
	 ( (string-equal choice "m") (my-macro-menu))
	 ( (string-equal choice "p") (my-points-menu))
	 ( (string-equal choice "r") (my-replace-menu))
	 ( (string-equal choice "t") (my-tags-menu))
	 ( (string-equal choice "x") (my-save-buffers-kill-emacs))
	 ( (string-equal choice "z") (my-bookmark-menu))
	 (t ()))
	))


;; terry's special menu, adapted for local use.
(setq
 my-special-keymap        (make-keymap "bar")
 my-secret-keymap         (make-keymap "secretbar")
 my-other-special-keymap (make-keymap "another-bar")
 my-fix-keymap    (make-keymap "fix")
 my-delete-keymap (make-keymap "delete"))

(mapc
 `(lambda (c)
	(let ((s (char-to-string c)))
	  (define-key my-fix-keymap s
		`(lambda ()
		   (interactive)
		   (my-fix-last ,s)))
	  (define-key my-delete-keymap s
		`(lambda ()
		   (interactive)
		   (my-delete-last ,s)))))
 my-fixable-chars)


(define-keys
  my-secret-keymap
  (list
   "o" 'windmove-left
   "u" 'windmove-right
   "." 'windmove-up
   "j" 'windmove-down
   "," 'delete-other-windows
   "p" 'split-window-right
   "k" 'split-window-below
   "e" 'delete-window
   "i" 'bookmark-set
   "a" '(lambda() (interactive) (bookmark-jump (my-get-bookmark-name "jump to")))
   ";" '(lambda() (interactive) (bookmark-rename (my-get-bookmark-name "rename")))
   "d" 'window-toggle-dedicated
   "D" 'edebug-defun
   "r" 'query-replace
;   "t" 'monitor-abbrevs-toggle
   "f" '(lambda() (interactive) (frame-configuration-to-register (read-char "register-letter: " nil 3)))
   [left] 'winner-undo
   [right] 'winner-redo
   ;; ";" 'ime-ffip
   ;; "'" 'ime-ffip-other-window
   [f7] 'my-cycle-visible-and-invisible-frames
   [f9] 'my-save-frame-config-to-register-and-switch-to-register
))
;; (define-key ime-bindings-map "\C-cf" 'ime-ffip)
;; (define-key ime-bindings-map "\C-c4f" 'ime-ffip-other-window)

(define-keys
  my-special-keymap
  (list
   "[" 'repeat-complex-command
   "]" 'repeat-matching-complex-command
   ";" 'my-load-current-file
   "/" 'hippie-expand
   "|" 'quote-to-end
   "a" 'iedit-mode
   "A" 'abbrev-mode
   "b" 'switch-to-buffer
   "B" 'buffer-filename-to-clipboard
   "c" 'my-abbrev-checker
   "C" 'my-byte-compile-current-file
   "d"  'list-defs
   "e" 'eval-last-sexp
   "E" 'edebug-defun
   "f" 'find-file-in-project
   "g" 'vc-git-grep
   "h" 'narrow-split-horiz-with-indirect
   "i" 'indent-region
   "I" 'ido-mode
   "j" 'comment-or-uncomment-region
   "k" 'kill-buffer
   "K" '(lambda() (interactive) (kill-buffer) (kill-buffer))
   "l" 'goto-line
   "m" 'my-main-menu
   "n" 'narrow-to-region-indirect
   "o" '(lambda() (interactive) (other-window 1))
   "O" 'my-make-frame-opaque
   "q" 'my-ispell-word-backwards
   "r" 'my-replace-last
   "R" '(lambda () (interactive) (revert-buffer nil t t))
   "s" 'save-buffer
   "S" 'smerge-mode
   "t" 'my-make-frame-transparent
   "T" 'my-make-frame-invisible
   "U" 'my-upcase-backwards
   "v" 'narrow-split-vert-with-indirect
   "w" 'ispell-word
   "x" 'my-make-all-other-frames-invisible
   "Y" 'yank-by-regexp
   "y" 'smerge-keep-current
   "z" 'find-file
   "Z" 'zone
   "$" 'magit-status
   "W" '(lambda () (interactive) (flyspell-check-previous-highlighted-word))
   [return] 'undo
   [backspace] 'toggle-frame-fullscreen
   [f7] my-fix-keymap
   "9" '(lambda ()
	  (interactive)
	  (my-fix-last "9"))))

(global-set-keys
  (list
   [f1] 'my-cycle-visible-and-invisible-frames
   [f7]   my-special-keymap
   [f9] my-secret-keymap
   "\C-x\C-c"          'my-save-buffers-kill-emacs
   "\M-g"              'kill-white-after
   [(shift return)]    'newline
   [(control return)]  'newline
   [(shift delete)]    'backward-delete-char-untabify
   [(control delete)]  'backward-delete-char-untabify
   [f5]                'delete-frame
   [f6]                '(lambda () (interactive) (make-frame-command) (toggle-frame-fullscreen))
   [(shift f6)]        '(lambda () ())
   [(control tab)]     'other-frame
 [(shift f5)] 'list-colors-display
   [f8]                'my-replace-menu
   "\C-\\"              'undo
   "\M-."              'hippie-expand
   "\M-n"              'end-of-next-line
   "\M-t"              'my-make-frame-invisible
   "\M-o"              'er/expand-region
   [end]               'dabbrev-expand
  "\M-p"               'isearch-backward
 "\C-e"               'end-of-line
 "\C-k"               'kill-line
 "\C-y"               'yank

  [prior]              'newline-and-indent))

(global-set-key (kbd "C-c f") 'find-file-in-project)

(provide 'bar-menus)
