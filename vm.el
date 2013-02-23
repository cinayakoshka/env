;; -------------------------------------------------------------------------
;; Paths
;; -------------------------------------------------------------------------

(setq vm-toolbar-pixmap-directory
      "/usr/local/share/vm/pixmaps"
      vm-image-directory
      "/usr/local/share/vm/pixmaps"  ;; "/Application/Aquamacs Emacs.app/Contents/Resources/etc/vm/"
      )

;; -------------------------------------------------------------------------
;; Viewing the mail
;; -------------------------------------------------------------------------

;; Use W3M to read HTML email
(require 'w3m-load)
;; (setq vm-mime-use-w3-for-text/html nil)
(load "vm-w3m")
(setq vm-url-browser 'w3m
      w3m-input-coding-system 'utf-8
      w3m-output-coding-system 'utf-8)

(require 'u-vm-color)
(add-hook 'vm-summary-mode-hook 'u-vm-color-summary-mode)
(add-hook 'vm-select-message-hook 'u-vm-color-fontify-buffer)

(setq vm-frame-per-edit nil
      ;; vm-frame-per-composition t
      vm-use-toolbar nil
      vm-mutable-frames t
      vm-mutable-windows t
      vm-startup-with-summary t
      vm-circular-folders t
      vm-follow-summary-cursor t
      vm-auto-center-summary t
      vm-auto-folder-case-fold-search t
      vm-search-using-regexps t
      vm-included-text-prefix "| "
      vm-reply-subject-prefix "Re: "
      vm-jump-to-new-messages t
      vm-circular-folders nil
      vm-fill-paragraphs-containing-long-lines nil
      vm-auto-displayed-mime-content-types t
      vm-auto-displayed-mime-content-type-exceptions '("audio")
      vm-mime-decode-for-preview t
      vm-auto-decode-mime-messages t
      vm-mime-internal-content-types '("text" "image")
      vm-mime-use-image-strips nil
      vm-mime-base64-decoder-program	"mmencode"
      vm-mime-base64-decoder-switches	'("-u" "-b")
      vm-mime-base64-encoder-program	"mmencode"
      vm-mime-base64-encoder-switches	'("-b")
      vm-mime-qp-decoder-program		"mmencode"
      vm-mime-qp-decoder-switches		'("-u" "-q")
      vm-mime-qp-encoder-program		"mmencode"
      vm-mime-qp-encoder-switches		'("-q")
      vm-auto-get-new-mail 5
      vm-move-after-deleting t
      vm-move-after-killing t
      vm-pop-expunge-after-retrieving t
      mail-archive-file-name (expand-file-name "~/mail/sent")
      vm-folder-directory '"~/mail/"
      vm-delete-after-archiving t
      vm-delete-after-saving t
      )



;; -------------------------------------------------------------------------
;; Composition
;; -------------------------------------------------------------------------

(add-hook 'vm-mode-hook
          '(lambda ()
             (make-local-variable 'file-precious-flag)
             (setq file-precious-flag t)))

;; send mail using utf-8.
;; (add-hook 'vm-mail-hook 'prep-my-mail)
;; (remove-hook 'mail-mode-hook (prep-my-mail))
;; (defun prep-my-mail ()
;;   (interactive)
;;   (set-buffer "mail to ?")
;;   (set-language-environment "utf-8")
;;   (save-excursion
;;     (goto-char (point-min))
;;     (insert "Content-Type: text/plain; charset=utf-8\n")))


;; -------------------------------------------------------------------------
;; getting the mail
;; -------------------------------------------------------------------------
(setq vm-spool-file-suffixes (list ".spool")
      vm-crash-box-suffix ".crash"
      vm-spooled-mail-interval 60
      vm-primary-inbox "~/mail/Inbox"
      )

(define-key vm-mode-map "u"
  '(lambda ()
     (interactive)
     (vm-visit-folder "~/mail/unsorted")))


;; -------------------------------------------------------------------------
;; sending the mail
;; -------------------------------------------------------------------------

;; (setq send-mail-function 'sendmail-send-it
;;       message-send-mail-function 'sendmail-send-it
;; )

(setq send-mail-function 'smtpmail-send-it
;;       message-send-mail-function 'smtpmail-send-it
      message-send-mail-function 'message-smtpmail-send-it
      smtpmail-starttls-credentials '(("smtp.gmx.com" 465 nil nil))
      smtpmail-smtp-server "smtp.gmx.com"
      smtpmail-default-smtp-server "smtp.gmx.com"
      smtpmail-smtp-service 465
      smtpmail-auth-credentials '(("smtp.gmx.com" 465
                                   "barcs@gmx.com" "q1$}Ri?b`^M"))
      starttls-use-gnutls t
      )

;; (setq password-cache-expiry 86400      ; Time (in sec) to cache SMTP password
;;       vm-stunnel-program "stunnel"
;;       mail-interactive nil
;;      )

;;(setq sendmail-program "/Users/stough/bin/mysendmail") ; ????

;; ------------------------------------------------------------------------ 
;; saving the mail
;; ------------------------------------------------------------------------ 


(setq vm-auto-folder-alist
      '(
        ("Subject: "
         )
        ("To: "
         ("csgrad@mail.cs.unm.edu" . "unm-lists")
         ("mcog@cs.unm.edu" . "unm-lists")
         ("zope3-users <Zope3-users@zope.org>" . "zope-lists")
         )
        ("From: "
         ("slt60@hotmail.com" . "acl")
         ("darko@tau.cs.unm.edu" . "558")
         ("tnguyen@cs.unm.edu" . "acl")
         ("mike97532@hotmail.com" . "friends-and-family") 
         ("dharpe2@uic.edu" . "friends-and-family")
         ("sales@clearcart.com" . "friends-and-family")
         ("bshirtcliff@hotmail.com" . "friends-and-family")
         ("mgoode2@uic.edu" . "friends-and-family")
         ("ranthrock@aol.com" . "friends-and-family")
         ("romain@tadaaa.net" . "friends-and-family")
         ("matthew@matthewtaylor.net" . "friends-and-family")
         ("iconja@gmail.com" . "friends-and-family")
         ("massmail_owner@uic.edu" . "Spam")
         ("casa.steve@charter.net" . "friends-and-family")
         ("Terry Jones" . "friends-and-family")
         ("emily" . "friends-and-family")
         ("moonmatrix@gmail.com" . "friends-and-family")
         ("bar.kurtz@gmail.com" . "sent")
         ("barbarashirtcliff@comcast.net" . "sent")
         ("Ben Shirtcliff" . "friends-and-family")
         ("daly@uic.edu" . "uic")
         ("jjcarlsen@hotmail.com" . "friends-and-family")
         ("iTunes Music Store - do_not_reply@apple.com" . "subscriptions")
         ("Russell Manley" . "friends-and-family")
         ("ana.mosterin@gmail.com" . "friends-and-family")
         ("eshirtcl@uno.edu" . "friends-and-family")
         ("bar.kurtz@gmail.com" . "sent")
         ("barshirtcliff@gmail.com" . "sent")
         ("bar.cs.unm.edu" . "sent")
         ("jason@jhbookdesign.com" . "clients")
         ("crazyuddie@yahoo.com" . "friends-and-family")
         ("gbezerra@cs.unm.edu" . "acl")
         ("lance.r.williams@gmail.com" . "cs")
         ("saia@cs.unm.edu" . "cs")
         ("stelleg@cs.unm.edu" . "acl")
         ("nguyenthanhvuh@gmail.com" . "acl")
         ("gbezerra@gmail.com" . "acl")
         ("BJEdwards@gmail.com" . "acl")
         ("eschulte@cs.unm.edu" . "acl")
         ("tgroves@unm.edu" . "cs")
         ("stelleg@gmail.com" . "acl")
         ("bedwards@cs.unm.edu" . "acl")
         ("sluan@cs.unm.edu" . "cs")
         ("kapur@cs.unm.edu" . "550")
         ("olegsa@cs.unm.ed" .  "cs")
         ("ackley@cs.unm.edu" . "cs")
         ("romain.ichbiah@gmail.com" . "friends-and-family")
         ("darnold@cs.unm.edu" . "hpc")
         ("to_ojo@hotmail.com" . "587")
         ("jluan01@unm.edu" . "587")
         )
        ("Sender: "
         ("aquamacs-devel-bounces@aquamacs.org" . "aquamacs")
         ("haskell-cafe-bounces@haskell.org" . "haskell")
         ("beginners-bounces@haskell.org" . "haskell")
         ("csgrad-bounces@mail.cs.unm.edu" . "csgrad")
         ("python-list-bounces+barshirtcliff=gmail.com@python.org" . "python")
         ("macosx-emacs-bounces@email.esm.psu.edu" . "macosx-emacs")
         ("cs587-bounces@mail.cs.unm.edu" . "587")
         ("fluiddb-users@googlegroups.com" . "fluiddb")
         ("mkd5m@virginia.edu" . "research")
         )
        ("To: "
         ("python-list@python.org" . "python")
         )
        ("Cc: "
         ("python-list@python.org" . "python")
         )
        )
      )


;; sig-quote
;; (setq sq-address-n-quote-type-alist
;;       '(
;;         ("*" . ("witty"))
;;         )
;;       sq-confirm-quote t
;;       sq-quote-file "~/quotations")

;; (setq sq-address-n-quote-type-alist
;;       '(("prof_apple@podunk\.edu" . ("witty"))
;;         ("sam@aol\.com"           . ("not so witty"))
;;         ("bob"                    . ("crude" "silly"))
;;         ("jill"                   . t)
;;         ("@cs\.berkeley\.edu"     . nil))))

;; email reply setting.  fm terry.
;; (defun email-from-kgmail ()
;;   (interactive)
;;   (and
;;    (fboundp 'vm-version)
;;    (setq vm-mail-header-from "Barbara Shirtcliff <bar.kurtz@gmail.com>"))
;;   (setq
;;    mail-default-reply-to            "barcs@gmx.com"
;;    user-mail-address                "bar.kurtz@gmail.com"
;;    mail-from-style                  'angles
;;    mail-envelope-from               "Barbara Shirtcliff <bar.kurtz@gmail.com"))

;; (defun email-from-unm ()
;;   (interactive)
;;   (and
;;    (fboundp 'vm-version)
;;    (setq vm-mail-header-from "Barbara Shirtcliff <bar@cs.unm.edu>"))
;;   (setq
;;    mail-default-reply-to            "barcs@gmx.com"
;;    user-mail-address                "bar@cs.unm.edu"
;;    mail-from-style                  'angles
;;    mail-envelope-from               "Barbara Shirtcliff <bar@cs.unm.edu"))

;; (defun email-from-gmail ()
;;   (interactive)
;;   (and
;;    (fboundp 'vm-version)
;;    (setq vm-mail-header-from "Bar Shirtcliff <barshirtcliff@gmail.com>"))
;;   (setq
;;    mail-default-reply-to            "bar@cs.unm.edu"
;;    user-mail-address                "barshirtcliff@gmail.com"
;;    mail-from-style                  'angles
;;    mail-envelope-from               "Bar Shirtcliff <barshirtcliff@gmail.com>"))


;; (setq vm-mail-header-from "Barbara Shirtcliff <barcs@gmx.com>"
;;       mail-default-reply-to            "barcs@gmx.com"
;;       user-mail-address                "barcs@gmx.com"
;;       mail-from-style                  'angles
;;       mail-envelope-from               "Barbara Shirtcliff <barcs@gmx.com>")

;; (defun my-set-reply-to ()
;;   (interactive)
;;   (save-excursion
;;     (cond
;;      ((progn
;; 	(goto-char (point-min))
;; 	(search-forward-regexp "^\\(?:To\\|X-Original-To\\|Cc\\|Bcc\\|From\\): .*bar\\.kurtz@gmail\\.com" (point-max) t))
;;       (message "reply-to = kgmail")
;;       (email-from-kgmail))
;;      ((progn
;;         (goto-char (point-min))
;;         (search-forward-regexp "^\\(?:To\\|X-Original-To\\|Cc\\|Bcc\\|From\\): .*barshirtcliff@gmail\\.com" (point-max) t))
;;       (message "reply-to = gmail")
;;       (email-from-gmail))
;;      ((progn
;;         (goto-char (point-min))
;;         (search-forward-regexp "^\\(?:To\\|X-Original-To\\|Cc\\|Bcc\\|From\\): .*bar@cs\\.unm\\.edu" (point-max) t))
;;       (message "reply-to = unm")
;;       (email-from-unm))

;;      (t
;;       (message "reply-to = unm [default case]")
;;       (email-from-gmail)))))



;; (add-hook 'vm-select-message-hook 'my-set-reply-to t)


;; ;; growl
;; (defcustom growler-notification-list
;;   '(("Barbara Shirtcliff <bshirt2@uic.edu>" . -2)
;;     )
;;   "List of priorities for particular email correspondents."
;;   :tag 'growl)



;; ------------------------------------------------------------------------ 
;; special
;; ------------------------------------------------------------------------ 


;; procmail
;; (setq tinyprocmail-:procmail-version "v3.11pre7")
;; (add-hook 'tinyprocmail-:load-hook 'tinyprocmail-install)
                                        ; (require 'tinyprocmail) 

;;;###autoload
(defun vma-fixup-html-paragraphs ()
  (interactive)
  (vm-edit-message)
  (goto-char (point-min))
  (re-search-forward "^$")
  (replace-regexp "<br>\n<br>" "<p>\n")
  (goto-char (point-min))
  (re-search-forward "^$")
  (replace-regexp "^<br>" "")
  (vm-edit-message-end))

;; (setq vm-send-using-mime nil)
;; (setq vm-mime-text/html-handler 'emacs-w3m)

;;  ------------------------------------------------------------------------
;; security
;;  ------------------------------------------------------------------------
;; (add-hook 'vm-mode-hook 'mc-install-read-mode)
;; (add-hook 'vm-summary-mode-hook 'mc-install-read-mode)
;; (add-hook 'vm-virtual-mode-hook 'mc-install-read-mode)
;; (add-hook 'vm-mail-mode-hook 'mc-install-write-mode)
;; (setq mc-encrypt-for-me t)
;; (setq mc-gpg-user-id "D29A5D76")
;; (mc-setversion "gpg")


