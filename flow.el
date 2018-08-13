;;
;; Copyright (c) 2016-present, Facebook, Inc.
;; All rights reserved.
;;
;; This source code is licensed under the BSD-style license found in the LICENSE
;; file in the root directory of this source tree. An additional grant of patent
;; rights can be found in the PATENTS file in the same directory.
;;

(defvar flow-mode-map (make-sparse-keymap))

(setq flow/binary "flow")

(defun flow/column-number-at-pos (pos)
  "column number at pos"
  (save-excursion (goto-char pos) (current-column)))

(defun flow/string-of-region ()
  "string of region"
  (if (use-region-p)
      (let ((begin (region-beginning))
            (end (region-end)))
        (format ":%d:%d,%d:%d"
                (line-number-at-pos begin)
                (flow/column-number-at-pos begin)
                (line-number-at-pos end)
                (flow/column-number-at-pos end)))
    ""))

(defun flow/start ()
  (shell-command (format "%s start" flow/binary)))

(defun flow/stop ()
  (shell-command (format "%s stop" flow/binary)))

(defun flow/status ()
  "Initialize flow"
  (interactive)
  (flow/start)
  (compile (format "%s status --from emacs; exit 0" flow/binary)))

(defun flow/type-at-pos ()
  "show type"
  (interactive)
  (let ((file (buffer-file-name))
        (line (line-number-at-pos))
        (col (current-column))
        (buffer (current-buffer)))
    (switch-to-buffer-other-window "*Shell Command Output*")
    (flow/start)
    (shell-command
     (format "%s type-at-pos --from emacs %s %d %d"
             flow/binary
             file
             line
             (1+ col)))
    (compilation-mode)
    (switch-to-buffer-other-window buffer)))

(defun flow/suggest ()
  "fill types"
  (interactive)
  (let ((file (buffer-file-name))
        (region (flow/string-of-region))
        (buffer (current-buffer)))
    (switch-to-buffer-other-window "*Shell Command Output*")
    (flow/start)
    (shell-command
     (format "%s suggest %s%s"
             flow/binary
             file
             region))
    (compilation-mode)
    (switch-to-buffer-other-window buffer)))

(defun flow/goto-definition ()
  "jump to definition"
  (interactive)
  (let ((file (buffer-file-name))
        (line (line-number-at-pos))
        (col (current-column))
        (buffer (current-buffer)))
    (switch-to-buffer-other-window "*Shell Command Output*")
    (flow/start)
    (shell-command
     (format "%s get-def --from emacs %s %d %d"
             flow/binary
             file
             line
             (1+ col)))
    (compilation-mode)))

(defun flow/autocomplete ()
  "autocomplete"
  (interactive)
  (let ((file (buffer-file-name))
        (line (line-number-at-pos))
        (col (current-column))
        (buffer (current-buffer)))
    (switch-to-buffer-other-window "*Shell Command Output*")
    (flow/start)
    (shell-command
     (format "%s autocomplete %s %d %d < %s"
             flow/binary
             file
             line
             (1+ col)
             file))
    (compilation-mode)
    (switch-to-buffer-other-window buffer)))

(bind-keys :map flow-mode-map
           ("M-." . flow/goto-definition)
           ("C-c C-/" . flow-suggest)
           ("C-c C-t" . flow/type-at-pos)
           ("C-c C-s" . flow/status)
           ("M-TAB" . flow/autocomplete))

(define-minor-mode flow-mode
  "Minor mode for working with JavaScript Flow types."
  :init-value nil
  :lighter " Flow"
  :keymap flow-mode-map)

(defun flow/maybe-start ()
  (interactive)
  (save-excursion
    (goto-char 1)
    (when (looking-at "^[[:space:]]*/[*/][[:space:]]*@flow")
      (flow-mode t))))

(add-hook 'kill-emacs-hook
  (lambda ()
    (flow/stop)))
