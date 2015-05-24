;; top-level: project names in projects
;; default: does it for current project.  with prefix for another project and accesses that menu.
;; second: nav choice by name (with autocomplete), regepx-in-contents, regepx-in-name, type, file-suffix
;; other functions: get github link (with line number)
(require 'cl)
(defvar (setq bsm-chars '("a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z" "1" "2" "3" "4" "5" "6" "7" "8" "9" "0" "`" "$" "&" "[" "{" "}" "(" "=" "*" ")" "+" "]" "!" "\#" "\." ">" "<" "\;" ":"))

(defvar bsm-projects-root "~/projects")
(defvar bsm-everything-root "~/projects/everything")
(defvar bsm-projects-hash (make-hash-table :size (length bsm-chars) :test 'equal))

;; (defvar bsm-project-choice nil "place to store choices.")

(genhash bsm-projects-hash bsm-chars (remove-if-not #'is-scala-project (directory-files "~/projects")))
(defun bsm-projects-menu () (interactive) (bar-dynamic-menu bsm-projects-hash 'goto-project))
(defun say (thing) (message (format "you chose %s" thing)))


(defun my-scala-search-menu()
  "defined in bar-scala.el"
  (interactive)
  (let* ((choices '("filename"
                    "goto-project"
                    "regexp-name"
                    "regexp-contents"
                    "type"
                    "suffix"))
    (ltrs '("f" "g" "r" "c" "t" "s"))
    (choice (my-choose choices ltrs)))
  (cond
   ((string-equal choice "f") (message "this is not yet defined"))
   ((string-equal choice "g") (bsm-projects-menu))
   ((string-equal choice "r") (message "this is not yet defined"))
   ((string-equal choice "c") (message "this is not yet defined"))
   ((string-equal choice "t") (message "this is not yet defined"))
   ((string-equal choice "s") (message "this is not yet defined"))
   )))

;; (defun select-project ()
;;   (interactive)
;;   (setq choice (bar-dynamic-menu bsm-projects-hash '(lambda (x) '(x))))
;;   (message (format "you chose %s" choice)))

(defun goto-project (project)
  (interactive)
  (find-file (format "%s/%s" bsm-projects-root project)))

(defun is-scala-project (name dir) (interactive)
       (let ((loc (format "%s/%s/src/main" dir name)))
         (and (not (string= name "."))
              (not (string= name ".."))
              (file-directory-p loc)
              (member "scala" (directory-files loc)))))

(defun get-project-head()
  (interactive)
  

(defun find-by-name (name)
  (interactive)
)  
