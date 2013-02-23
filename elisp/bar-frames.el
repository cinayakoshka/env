
(defun make-other-frames-translucent ()
  (interactive)
  (let ((visible-frames (visible-frame-list))
        (current-frame (selected-frame)))
    (while visible-frames
      (let ((this-frame (pop visible-frames)))
        (if (eql this-frame current-frame)
            (set-frame-parameter this-frame 'alpha 100)
          (set-frame-parameter this-frame 'alpha 70))))))
(defun my-make-frame-opaque ()
  (interactive)
  (modify-frame-parameters (selected-frame) '((alpha . 99))))

(defun my-make-frame-transparent ()
  (interactive)
  (modify-frame-parameters (selected-frame) '((alpha . 57))))

;; borrowed from http://www.emacswiki.org/emacs/CustomizeAquamacs
;; ----------------------------------------------------------------------
(defun transparency-set-initial-value ()
  "Set initial value of alpha parameter for the current frame"
  (interactive)
  (if (equal (frame-parameter nil 'alpha) nil)
      (set-frame-parameter nil 'alpha 100)))

(defun transparency-set-value (numb)
  "Set level of transparency for the current frame"
  (interactive "nEnter transparency level in range 0-100: ")
  (if (> numb 100)
      (message "Error! The maximum value for transparency is 100!")
    (if (< numb 0)
	(message "Error! The minimum value for transparency is 0!")
      (set-frame-parameter nil 'alpha numb))))

(defun transparency-increase ()
  "Increase level of transparency for the current frame"
  (interactive)
  (transparency-set-initial-value)
   (if (> (frame-parameter nil 'alpha) 0)
       (set-frame-parameter nil 'alpha (+ (frame-parameter nil 'alpha) -2))
     (message "This is a minimum value of transparency!")))

(defun transparency-decrease ()
  "Decrease level of transparency for the current frame"
  (interactive)
  (transparency-set-initial-value)
  (if (< (frame-parameter nil 'alpha) 100)
      (set-frame-parameter nil 'alpha (+ (frame-parameter nil 'alpha) +2))
    (message "This is a minimum value of transparency!")))

;; sample keybinding for transparency manipulation
(global-set-key (kbd "C-?") 'transparency-set-value)
;; the two below let for smooth transparency control
(global-set-key (kbd "C-.") 'transparency-increase)
(global-set-key (kbd "C-,") 'transparency-decrease)
;; ----------------------------------------------------------------------
(defun my-make-frame-invisible ()
  (interactive)
  (make-frame-invisible nil t)
  (other-frame 1)
  )

(defun my-cycle-visible-and-invisible-frames ()
  (interactive)
  (define-hash-table-test 'contents-hash 'equal 'sxhash)
  (let ((frames (make-hash-table :test 'contents-hash))
        (allframes (frame-list))
        (inv nil))
    (mapcar '(lambda (buffer)
               (puthash buffer t frames))
            (visible-frame-list))
    (while (and
            (eql inv nil)
            allframes)
      (if (gethash (car allframes) frames)
          (setq allframes (cdr allframes))
        (setq inv (car allframes))))
    (if inv
        (progn
          (make-frame-visible inv)
          (raise-frame inv)
          (select-frame-set-input-focus inv))
      (message "all frames are now up."))))
    
(defun my-make-all-other-frames-invisible ()
  (interactive)
  (define-hash-table-test 'contents-hash 'equal 'sxhash)
  (let ((frames (make-hash-table :test 'contents-hash))
        (cframe (selected-frame)))
    (mapcar '(lambda (frame)
               (puthash frame t frames))
            (visible-frame-list))
    (maphash '(lambda (frame fakevalue)
                (if (not (eql frame cframe))
                    (make-frame-invisible frame)
                  fakevalue))
             frames)))
(provide 'bar-frames)