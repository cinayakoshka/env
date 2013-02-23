(defun switch-default-frame-alist (newlist)
(interactive)
(setq last-frame-alist default-frame-alist
default-frame-alist newlist)
)


(defvar navyblue-frame-alist
      '(
        (foreground-color . "thistle2")
        (background-color . "navyblue")
        (cursor-color . "white"))
      )

(defvar red-frame-alist
      '(
        (foreground-color . "thistle2")
        (background-color . "red4")
        (cursor-color . "orange1"))
      )

(defvar white-frame-alist
      '(
        (foreground-color . "black")
        (background-color . "white")
        (cursor-color . "green"))
      )

(defvar purple-frame-alist
      '(
        (foreground-color . "seashell")
        (background-color . "mediumpurple4")
        (cursor-color . "red"))
      )


(defvar black-frame-alist
      '(
        (foreground-color . "thistle2")
        (background-color . "black")
        (cursor-color . "green"))
      )


(defvar soft-grey-frame-alist
      '(
        (foreground-color . "black")
        (background-color . "gray42")
        (cursor-color . "green"))
      )

(defvar lavender-frame-alist
      '(
        (foreground-color . "MidnightBlue")
        (background-color . "lavender")
        (cursor-color . "red"))
      )

(provide 'bar-colors)
