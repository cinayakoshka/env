(add-hook 'mail-mode-hook '(lambda () (setq fill-column 70)))

(autoload 'mc-install-write-mode "mailcrypt" nil t)
(autoload 'mc-install-read-mode "mailcrypt" nil t)
(add-hook 'mail-mode-hook 'mc-install-write-mode)
(setq mc-remailer-user-chains
	  '(("default" "panta" "dizum" "metacolo" "zerofree")
		("strong" (shuffle-vector ["dizum" "zerofree" "panta" "metacolo"])))

          mc-encrypt-for-me t
          mc-pgp-always-sign t
          mc-passwd-timeout 600
          mc-always-replace 'never)

;; sig-quote
(setq sq-address-n-quote-type-alist
      '(("*" . ("witty"))
        )
      sq-confirm-quote t
      sq-quote-file "~/quotations")

;; email reply setting.  fm terry.
(defun email-from-kgmail ()
  (interactive)
  (and
   (fboundp 'vm-version)
   (setq vm-mail-header-from "Barbara Shirtcliff <bar.kurtz@gmail.com>"))
  (setq
    mail-default-reply-to            "bar.kurtz@gmail.com"
    user-mail-address                "bar.kurtz@gmail.com"
    mail-from-style                  'angles
    mail-envelope-from               "Barbara Shirtcliff <bar.kurtz@gmail.com"))

(defun email-from-unm ()
  (interactive)
  (and
   (fboundp 'vm-version)
   (setq vm-mail-header-from "Barbara Shirtcliff <bar@cs.unm.edu>"))
  (setq
    mail-default-reply-to            "bar@cs.unm.edu"
    user-mail-address                "bar@cs.unm.edu"
    mail-from-style                  'angles
    mail-envelope-from               "Barbara Shirtcliff <bar@cs.unm.edu"))

(defun email-from-gmail ()
  (interactive)
  (and
   (fboundp 'vm-version)
   (setq vm-mail-header-from "Bar Shirtcliff <barshirtcliff@gmail.com>"))
  (setq
    mail-default-reply-to            "barshirtcliff@gmail.com"
    user-mail-address                "barshirtcliff@gmail.com"
    mail-from-style                  'angles
    mail-envelope-from               "Bar Shirtcliff <barshirtcliff@gmail.com>"))

(defun my-set-reply-to ()
  (interactive)
  (save-excursion
    (cond
     ((progn
	(goto-char (point-min))
	(search-forward-regexp "^\\(?:To\\|X-Original-To\\|Cc\\|Bcc\\|From\\): .*bar\\.kurtz@gmail\\.com" (point-max) t))
      (message "reply-to = kgmail")
      (email-from-kgmail))
     ((progn
        (goto-char (point-min))
        (search-forward-regexp "^\\(?:To\\|X-Original-To\\|Cc\\|Bcc\\|From\\): .*barshirtcliff@gmail\\.com" (point-max) t))
      (message "reply-to = gmail")
      (email-from-gmail))
     ((progn
        (goto-char (point-min))
        (search-forward-regexp "^\\(?:To\\|X-Original-To\\|Cc\\|Bcc\\|From\\): .*bar@cs\\.unm\\.edu" (point-max) t))
      (message "reply-to = unm")
      (email-from-unm))

     (t
      (message "reply-to = unm [default case]")
      (email-from-gmail)))))
	   
(add-hook 'vm-select-message-hook 'my-set-reply-to t)
