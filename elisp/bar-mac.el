;; mac-specific hacks.

;; growl related stuff.  growl is an event notifier.

(add-hook 'vm-arrived-message-hook 'my-emacs-growl-this-message)

(defun growl-on ()
  (interactive)
(add-hook 'vm-arrived-message-hook 'my-emacs-growl-this-message)
  )

(defun growl-off ()
  (interactive)
  (remove-hook 'vm-arrived-message-hook 'my-emacs-growl-this-message)
  )


(defun my-emacs-growl-this-message ()
  (goto-char (point-min))
  (let* ((sender
          (progn
            (re-search-forward "From: \\([^\n]+\\)\n" nil t)
             (match-string-no-properties 1)))
         (subject
          (progn
            (set-match-data nil)
            (re-search-forward "Subject: \\([^\n]+\\)*\n" nil t)
            (match-string-no-properties 1)))
         (pre-assigned-priority (assoc sender growler-notification-list))
         (priority
          (if pre-assigned-priority
              (cdr pre-assigned-priority)
            0)))
    (shell-command
      (format
      "growlnotify -m \"%s\" -t \"%s\" -n VM -a Emacs.app %s -d VM  -p %d"
      subject sender (if (> priority 0) "-s" " ") priority))
    (message "mail from %s: %s" sender subject)))

(provide 'bar-mac)