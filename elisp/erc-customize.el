(require 'erc)
(require 'erc-truncate)
(require 'tls)
(setq erc-hide-list '("JOIN" "PART" "QUIT"))
(setq erc-keywords '("\\(barx\\|capers\\|satan\\|wolves\\)")
      erc-keyword-highlight-type 'all
      erc-current-nick-highlight-type 'all)
(erc-match-mode 1)

(defun erc-simple () (interactive) 
      (erc-tls :server "chat.banksimple.com" :port 9999 :nick "barx"
               :password irc-password))

(setq erc-server-auto-reconnect nil)

(setq erc-log-matches-types-alist
      '((keyword . "&activity")
        (current-nick . "&activity")))

(erc-track-mode t)

(add-to-list 'erc-hide-list "NICK")

(defun irc-start ()
  "Connect to ERC, or switch to last active buffer"
  (interactive)
  (if (get-buffer "chat.simple.com:9999") ;; ERC already active?
      (erc-track-switch-buffer 1) ;; yes: switch to last active
    (when (y-or-n-p "Start ERC? ") ;; no: maybe start ERC
      (require 'secrets "~/.emacs.d/secrets.el.gpg")
      (erc-tls :server    "chat.banksimple.com"
	       :port      9999
	       :nick      "barx"
	       :full-name "barx"
	       :password  irc-password)
      (setq erc-prompt "    >"
	    erc-pcomplete-nick-postfix ","
	    erc-max-buffer-size 50000
	    erc-server-303-functions nil
	    erc-autojoin-timing :ident
	    erc-flood-protect nil
	    erc-timestamp-only-if-changed-flag t
	    erc-timestamp-format "%H:%M "
	    erc-fill-prefix "      "
	    erc-fill-column 70
	    erc-insert-timestamp-function 'erc-insert-timestamp-left))))


(add-hook 'erc-text-matched-hook 'my-erc-hook)
;; (remove-hook 'erc-text-matched-hook 'my-erc-hook)

(defun my-erc-hook (match-type nick message)
  "Shows a growl notification, when user's nick was mentioned. If the buffer is currently not visible, makes it sticky."
  "Notify the current user when someone sends a message that
matches a regexp in `erc-keywords'."
  (when (and (or (eq match-type 'keyword) (eq match-type 'current-nick))
	     ;; I don't want to see anything from the erc server
	     (null (string-match "\\`\\([sS]erver\\|localhost\\)" nick))
	     ;; or bots
	     (null (string-match "\\(bot\\|serv\\)!" nick)))
    (growl
     (concat "ERC: " (buffer-name (current-buffer))) (concat nick ": " message))))

;; (defvar growlnotify-command (executable-find "growlnotify") "The path to growlnotify")
(setq growlnotify-command "/usr/local/bin/growlnotify")

(defun growl (title message)
  "Shows a message through the growl notification system using
 `growlnotify-command` as the program."
  (flet ((encfn (s) (encode-coding-string s (keyboard-coding-system))) )
    (let* ((process (start-process growlnotify-command
				   nil
				   growlnotify-command
				   "-t" (encfn title)
				   "-a" "Emacs"
				   "-n" "Emacs"
				   "-m" (encfn message))))
      (process-send-eof process)) t))
 

(setq erc-server-send-ping-interval nil)
(add-to-list 'erc-modules 'hl-nicks 'log)

(setq erc-save-buffer-on-part nil
      erc-save-queries-on-quit nil
      erc-log-write-after-send t
      erc-log-write-after-insert t)

;; (add-hook 'erc-connect-pre-hook '(lambda (x) (erc-update-modules)))
(add-hook 'erc-insert-post-hook 'erc-truncate-buffer)
(add-hook 'erc-mode-hook
	  '(lambda ()
	     (linum-mode 0)))
(require 'erc-log)
(setq erc-log-mode t)

(defun erc-cmd-CALM ()
  (erc-send-message "┬─┬ノ(º_ºノ)"))

(defun erc-cmd-THROW (&rest words)
  (let ((subj (if words (flip-text (mapconcat 'identity words " ")) "┻━┻")))
    (erc-send-message (mapconcat 'identity (list "(ノಠ益ಠ)ノ彡" subj) ""))))

(defun erc-next-link (arg)
  "Move point to the ARGth URL, or the end of the buffer if none."
  (interactive "p")
  (or (re-search-forward erc-button-url-regexp (point-max) t arg)
      (goto-char (point-max))))

(defun erc-previous-link (arg)
  "Move point to the ARGth most recent URL."
  (interactive "p")
  (when (looking-at erc-button-url-regexp)
    (re-search-backward "\\\s"))
  (re-search-backward erc-button-url-regexp 0 t))

(define-key erc-mode-map "\C-cp" 'erc-previous-link)
(define-key erc-mode-map "\C-cn" 'erc-next-link)

(defun erc-restart () (interactive)
  (kill-buffer "chat.banksimple.com:9999")
  (irc-start))


(provide 'erc-customize)
