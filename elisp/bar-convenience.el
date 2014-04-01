;; this is from Ian Eure
(defun window-toggle-dedicated (&optional window)
  "Toggle the dedicated flag on a window."
  (interactive)
  (let* ((window (or window (selected-window)))
         (dedicated (not (window-dedicated-p window))))
    (when (called-interactively-p)
      (message (format "%s %sdedicated"
                       (buffer-name (window-buffer window))
                       (if dedicated "" "un"))))
    (set-window-dedicated-p window dedicated)
    dedicated))


;; I did not write these.

(defun my-call-last-kbd-macro(num)
(interactive "nNum")
  (let* ( (num (read-from-minibuffer "Number of times to call: "))
		  )

 (message (concat "yr num: " num))
	( call-last-kbd-macro num)
	))
  
(defun my-start-or-end-kbd-macro ()
   (if defining-kbd-macro
      (end-kbd-macro)
    (start-kbd-macro nil)))

(defun my-save-buffers-kill-emacs ()
  "Defined in: ~/emacs/my-elisp/my-misc.el. Instead of killing, prompt for 'Really?'"
  (interactive)
  (if (yes-or-no-p "Really kill emacs? ")
      (save-buffers-kill-emacs)))

(defun my-bind(funcname)
  " Defined in: ~/emacs/my-elisp/my-misc.el.  Bind a function to Shift-F8."
  (interactive "CBind S-F8 key to func: ")
  (global-set-key [S-f8] funcname)
  )


(defun my-get-cwd()
  "Defined in: ~/emacs/my-elisp/my-misc.el.
  Return value of current working directory of current buffer."
  (interactive)
  (file-name-directory (expand-file-name 
						(buffer-file-name)))
  )

;; (defcustom last-replace-string "" nil)
;; (defvar last-replace-type "" nil)

(defun my-wrap-replace-menu-selection(func)
  (setq last-replace-type func)
  func)

;; (defun my-redo-last-interactive-replace(arg)
;;   (interactive "P")
  



;; (defun my-kill-buffers-matching-regexp (s)
;;   (interactive "sRegexp: ")
;;   (let ((buffers (list-buffers-noselect t)))
;;     (save-excursion
;;       (set-buffer "*Buffer List*")
;;       (goto-char (point-min))
;;       (while (re-search-forward s nil t)
;;         (beginning-of-line)
;;         (if (yes-or-no-p (concat "kill buffer "
;;                              (buffer-substring
;;                               (progn (re-search-forward " *\*? +\\(\\w\\)" nil t)
;;                                      ()
;;                                      (point))
;;                               (progn (re-search-forward "[ \t]" nil t)
;;                                      (backward-char 1)
;;                                      (point)))
;;                              " "
;;                              ))

(defun buffer-filename-to-clipboard()
  (interactive)
 (kill-new buffer-file-name)
)

(defun narrow-with-indirect(start end)
  (interactive "r")
  (deactivate-mark)
  (switch-to-buffer (clone-indirect-buffer nil nil))
  (narrow-to-region start end))

(defun narrow-split-horiz-with-indirect(start end)
  (interactive "r")
  (split-window-below)
  (windmove-down)
  (deactivate-mark)
  (switch-to-buffer (clone-indirect-buffer nil nil))
  (narrow-to-region start end))


(defun narrow-split-vert-with-indirect(start end)
  (interactive "r")
  (split-window-right)
  (windmove-right)
  (deactivate-mark)
  (switch-to-buffer (clone-indirect-buffer nil nil))
  (narrow-to-region start end))


(defun window-toggle-dedicated (&optional window)
  "Toggle the dedicated flag on a window."
  (interactive)
  (let* ((window (or window (selected-window)))
         (dedicated (not (window-dedicated-p window))))
    (when (called-interactively-p)
      (message (format "%s %sdedicated"
                       (buffer-name (window-buffer window))
                       (if dedicated "" "un"))))
    (set-window-dedicated-p window dedicated)
    dedicated))

;; (defun balance-windows-vertically()
;;   (interactive)
;;   (assoc 'height (frame-parameters))
;;   (assoc 'width (frame-parameters))
;; )

;; (defun this-frame-size-to-default()
;; (interactive)
;;   (setq (assoc 'height (frame-parameters)) (assoc 'height default-frame-alist)
;; 	(assoc 'width (frame-parameters))) (assoc 'width  default-frame-alist)
;; )






(defun narrow-to-region-indirect (start end)
  "Restrict editing in this buffer to the current region, indirectly."
  (interactive "r")
  (deactivate-mark)
  (let ((buf (clone-indirect-buffer nil nil)))
    (with-current-buffer buf
      (narrow-to-region start end))
      (switch-to-buffer buf)))

(provide 'bar-convenience)
