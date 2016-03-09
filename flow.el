;;
;; Copyright (c) 2016-present, Facebook, Inc.
;; All rights reserved.
;;
;; This source code is licensed under the BSD-style license found in the LICENSE
;; file in the root directory of this source tree. An additional grant of patent
;; rights can be found in the PATENTS file in the same directory.
;;

(setq flow_binary "flow")

(defun column-number-at-pos (pos)
  "column number at pos"
  (save-excursion (goto-char pos) (current-column))
)

(defun string-of-region ()
  "string of region"
  (if (use-region-p)
      (let ((begin (region-beginning))
            (end (region-end)))
        (format ":%d:%d,%d:%d"
                (line-number-at-pos begin)
                (column-number-at-pos begin)
                (line-number-at-pos end)
                (column-number-at-pos end)))
    "")
)

(defun get-assoc-value (key alist)
  "get assoc value"
  (setq blah (assoc key alist))
  (if blah
      (cdr blah)
    nil)
)

(defun flow-start ()
  (shell-command (format "%s start" flow_binary))
)

(defun flow-stop ()
  (shell-command (format "%s stop" flow_binary))
)

(defun flow-status ()
  "Initialize flow"
  (interactive)
  (flow-start)
  (compile (format "%s status --from emacs; exit 0" flow_binary))
)

(global-set-key (kbd "C-x C-m") 'flow-status)

(defun flow-type-at-pos ()
  "show type"
  (interactive)
  (let ((file (buffer-file-name))
        (line (line-number-at-pos))
        (col (current-column))
        (buffer (current-buffer)))
    (switch-to-buffer-other-window "*Shell Command Output*")
    (flow-start)
    (shell-command
     (format "%s type-at-pos --from emacs %s %d %d"
             flow_binary
             file
             line
             (1+ col)))
    (compilation-mode)
    (switch-to-buffer-other-window buffer))
)

(global-set-key (kbd "C-c C-t") 'flow-type-at-pos)

(defun flow-suggest ()
  "fill types"
  (interactive)
  (let ((file (buffer-file-name))
        (region (string-of-region))
        (buffer (current-buffer)))
    (switch-to-buffer-other-window "*Shell Command Output*")
    (flow-start)
    (shell-command
     (format "%s suggest %s%s"
             flow_binary
             file
             region))
    (compilation-mode)
    (switch-to-buffer-other-window buffer))
)

(global-set-key (kbd "C-t") 'flow-suggest)

(defun flow-get-def ()
  "jump to definition"
  (interactive)
  (let ((file (buffer-file-name))
        (line (line-number-at-pos))
        (col (current-column))
        (buffer (current-buffer)))
    (switch-to-buffer-other-window "*Shell Command Output*")
    (flow-start)
    (shell-command
     (format "%s get-def --from emacs %s %d %d"
             flow_binary
             file
             line
             (1+ col)))
    (compilation-mode))
)

(global-set-key (kbd "M-.") 'flow-get-def)

(defun flow-autocomplete ()
  "autocomplete"
  (interactive)
  (let ((file (buffer-file-name))
        (line (line-number-at-pos))
        (col (current-column))
        (buffer (current-buffer)))
    (switch-to-buffer-other-window "*Shell Command Output*")
    (flow-start)
    (shell-command
     (format "%s autocomplete %s %d %d < %s"
             flow_binary
             file
             line
             (1+ col)
             file))
    (compilation-mode)
    (switch-to-buffer-other-window buffer))
)

(global-set-key (kbd "M-TAB") 'flow-autocomplete)

(add-hook 'kill-emacs-hook
  (lambda ()
    (flow-stop)))
