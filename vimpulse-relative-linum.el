(require 'linum+) ;; See http://github.com/tarao/elisp/raw/master/linum+.el

(defgroup vimpulse-relative-linum nil
  "Relative line numbers when operators are activated."
  :prefix "vimpulse-relative-linum-"
  :group 'vimpulse)

(defcustom vimpulse-relative-linum-delay 0.3
  "Delay in showing line numbers after the operator is activated."
  :group 'vimpulse-relative-linum
  :type 'float)

(defvar vimpulse-relative-linum-timer nil)
(defvar vimpulse-relative-linum-activated nil)

(define-minor-mode vimpulse-relative-linum-mode
  "Show relative line numbers when operators are activated."
  :group 'vimpulse-relative-linum
  (let ((exit-cmd `(lambda ()
                     (interactive)
                     (save-excursion (set-buffer ,(current-buffer))
                                     (vimpulse-relative-linum-off)))))
    (if vimpulse-relative-linum-mode
        (progn
          (add-hook 'pre-command-hook exit-cmd)
          (add-hook 'post-command-hook exit-cmd)
          (setq vimpulse-relative-linum-timer
                (run-with-idle-timer vimpulse-relative-linum-delay nil
                                     'vimpulse-relative-linum-activate)))
      (cancel-timer vimpulse-relative-linum-timer)
      (when vimpulse-relative-linum-activated
        (relative-linum-mode 0)
        (setq vimpulse-relative-linum-activated nil))
      (remove-hook 'pre-command-hook exit-cmd)
      (remove-hook 'post-command-hook exit-cmd))))

(defun vimpulse-relative-linum-off ()
  (interactive)
  (vimpulse-relative-linum-mode 0))

(defun vimpulse-relative-linum-on ()
  (interactive)
  (vimpulse-relative-linum-mode 1))

(defun vimpulse-relative-linum-activate ()
  (setq vimpulse-relative-linum-activated t)
  (relative-linum-mode 1))

(add-hook 'vimpulse-operator-state-hook 'vimpulse-relative-linum-on)

(provide 'vimpulse-relative-linum)
