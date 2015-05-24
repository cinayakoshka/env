
(require 'rcirc)
(defvar pmtimer)
(defun simple-rcirc () (interactive)
       (kill-stale-rcirc-windows)
       (rcirc-connect "chat.banksimple.com"
               "9999"
               "barx"
               "bar"
               "Barbara Shirtcliff"
               nil
               (tom-get-keychain-password "chat.banksimple.com:9999:bar")
               'tls)
       )

(defun lspms () (interactive)
       (save-excursion (shell-command "ls -ltc ~/.rcirc-logs | grep -v \"#\"" "*PMS*")))
(cancel-function-timers 'lspms)

(defun freenode-rcirc () (interactive)
       (rcirc-connect "irc.freenode.net"
               "6667"
               "barx"
               "bar"
               "Barbara Shirtcliff"
               nil
               (tom-get-keychain-password "irc.freenode.net:6667:barx")
               'plain))

(defun kill-stale-rcirc-windows () (interactive)
       (setq list (buffer-list))
       (setq bad1 "killed: 9 (signal)
> "
             bad2 "finished (exit)
> ")
         (while list
           (let* ((buffer (car list))
                  (name (buffer-name buffer)))
             (and name
                  (not (string-equal name ""))
                  (/= (aref name 0) ?\s)
                  (progn
                    (setq bufferend (nab-last-two-lines name))
                    (or (string-suffix-p bad1 bufferend)
                        (string-suffix-p bad2 bufferend)))
                  (kill-buffer name))
                  (setq list (cdr list)))
       ))

(defun nab-last-two-lines (name) (interactive)
       (save-current-buffer
         (save-excursion
           (set-buffer name)
           (goto-char (point-max))
            (ignore-errors
              (previous-line 1)
              (beginning-of-line)
              (buffer-substring-no-properties (point) (point-max))))
         )
       )

;; from http://www.emacswiki.org/emacs/rcircLogging
 ;;; Minimal logging to `~/.rcirc-logs/channel'
 ;;; by courtesy of Trent Buck.
(add-hook 'rcirc-print-hooks 'rcirc-write-log)
;; (defcustom rcirc-log-directory "~/.rcirc-logs"
;;   "Where logs should be kept.  If nil, logs aren't kept.")
(defun rcirc-write-log (process sender response target text)
  (when rcirc-log-directory
    (with-temp-buffer
      ;; Sometimes TARGET is a buffer :-(
      (when (bufferp target)
        (setq target (with-current-buffer buffer rcirc-target)))
      ;; Sometimes buffer is not anything at all!
      (unless (or (null target) (string= target ""))
        ;; Print the line into the temp buffer.
        (insert (format-time-string "%Y-%m-%d %H:%M "))
        (insert (format "%-16s " (rcirc-user-nick sender)))
        (unless (string= response "PRIVMSG")
          (insert "/" (downcase response) " "))
        (insert text "\n")
        ;; Append the line to the appropriate logfile.
        (let ((coding-system-for-write 'no-conversion))
          (write-region (point-min) (point-max)
                        (concat rcirc-log-directory "/" (downcase target))
                        t 'quietly))))))

;; http://www.emacswiki.org/emacs/rcircDimNicks
(defadvice rcirc-format-response-string (after dim-entire-line)
  "Dim whole line for senders whose nick matches `rcirc-dim-nicks'."
  (when (and rcirc-dim-nicks sender
             (string-match (regexp-opt rcirc-dim-nicks 'words) sender))
    (setq ad-return-value (rcirc-facify ad-return-value 'rcirc-dim-nick))))
(ad-activate 'rcirc-format-response-string)


;; http://www.emacswiki.org/emacs/rcircNoNamesOnJoin
(defvar rcirc-hide-names-on-join t                                                                               
   "Non-nil if nick names list should be hidden when joining a channel.")                                         
                                                                                                                  
 (defadvice rcirc-handler-353 (around my-aad-rcirc-handler-353 activate)                                          
   "Do not render NICK list on join when `rcirc-hide-names-on-join' is non-nil.                                   
 RPL_NAMREPLY."                                                                                                   
   (when (not rcirc-hide-names-on-join)                                                                           
     ad-do-it))                                                                                                   
                                                                                                                  
 (defadvice rcirc-handler-366 (around my-aad-rcirc-handler-366 activate)                                          
   "Do not render NICK list on join when `rcirc-hide-names-on-join' is non-nil.                                   
 RPL_ENDOFNAMES."                                                                                                 
   (when (not rcirc-hide-names-on-join)                                                                           
     ad-do-it))                                                                                                   
                                                                                                                  
 (defadvice rcirc-handler-JOIN (around my-before-ad-rcirc-handler-join-no-names activate)                         
   "Set `rcirc-hide-names-on-join' to `t'."                                                                       
   ad-do-it                                                                                                       
   (setq rcirc-hide-names-on-join t))                                                                             

(defadvice rcirc-cmd-names (before my-ad-rcirc-cmd-names-no-list activate)                                       
  "Reset rcirc-hide-names-on-join to nil after the JOIN step."                                                   
  (setq rcirc-hide-names-on-join nil))

;; this is obviously from tom
(defun tom-get-keychain-password (account-name)
  "Gets `account` keychain password from OS X Keychain"
  (trim
   (shell-command-to-string
    (concatenate
     'string
     "security find-generic-password -wa "
     account-name))))

;; from ieure
(defun trim (text)
  "Trim whitespace from the beginning and end of text."
  (replace-regexp-in-string "\\(^ +\\| +$\\|\n+\\)" "" text))


(require 'rcirc-color)
(require 'rcirc-auto-away)
(require 'rcirc-help)
(provide 'bar-rcirc)
