(require 'find-file-in-project)
 
(add-to-list 'ffip-patterns "*.scala")
(add-to-list 'ffip-patterns "*.java")
;; (add-to-list 'ffip-patterns "*.sql")

(add-to-list 'ffip-patterns "*.rb")
(add-to-list 'ffip-patterns "*.yml")
(add-to-list 'ffip-patterns "*.c")
(add-to-list 'ffip-patterns "*.cpp")
(add-to-list 'ffip-patterns "*.h")
(add-to-list 'ffip-prune-patterns ".idea")
;; (add-to-list 'ffip-prune-patterns "*.sql")
(setq ffip-find-options "-not -path '.*\.idea.*'")
 
(defmacro with-ido (&rest body)
  "Evaluate BODY with ido-mode enabled."
  (let ((save-symbol (gensym "with-ido-save")))
    `(let ((,save-symbol (or ido-mode -1)))
       (unwind-protect
           (progn
             (ido-mode 1)
             ,@body)
         (ido-mode ,save-symbol)))))
 
(defvar ffip-last-project-root nil)
 
(defun ffip-current-project-root-or-last ()
  "Use the last ffip project root if none is available here."
  (let ((ffip-project-root-function))
    (setq ffip-last-project-root
          (or (ffip-project-root) ffip-last-project-root))))
 
(setq ffip-project-root-function 'ffip-current-project-root-or-last)
 
(defmacro wrap-ffip (ffip-fun)
  `(with-ido
    (let ((completion-ignore-case t)
          (ido-case-fold t))
      (call-interactively ,ffip-fun))))
 
(defun ime-ffip ()
  (interactive)
  (wrap-ffip 'ffip))
 
(defun ime-ffip-other-window ()
  (interactive)
  (wrap-ffip 'ffip-other-window))
 
(defun find-file-in-project-other-window ()
  "Prompt with a completing list of all files in the project to find
one.  The project's scope is defined as the first directory containing
an `.emacs-project' file.  You can override this by locally setting
the variable `ffip-project-root'."
  (interactive)
  (switch-to-buffer-other-window
   (save-window-excursion
     (call-interactively 'find-file-in-project))))
 
(defalias 'ffip-other-window 'find-file-in-project-other-window)
(provide 'ffip)
