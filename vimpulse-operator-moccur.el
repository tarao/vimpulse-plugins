(require 'color-moccur)

(defgroup vimpulse-operator-moccur nil
  "Moccur operator for Vimpulse"
  :prefix "vimpulse-operator-moccur-"
  :group 'vimpulse)

(defcustom vimpulse-operator-moccur-grep-find-key (kbd "M")
  "A key for moccur-grep-find operator"
  :type `,(if (get 'key-sequence 'widget-type)
              'key-sequence
            'sexp)
  :group 'vimpulse-operator-moccur)

(defcustom vimpulse-operator-moccur-use-current-directory nil
  "Uses current directory for grep and does not ask interactively."
  :type 'boolean
  :group 'vimpulse-operator-moccur)

(defun vimpulse-moccur-grep-find-region (beg end &optional dir)
  (interactive "r")
  (unless dir
    (setq dir (or (and (not vimpulse-operator-moccur-use-current-directory)
                       (moccur-grep-read-directory))
                  (file-name-directory (buffer-file-name)))))
  (moccur-grep-find dir (list (buffer-substring-no-properties beg end))))

(vimpulse-convert-to-operator vimpulse-moccur-grep-find-region)
(vimpulse-define-key 'vimpulse-operator-moccur-mode 'vi-state
                     vimpulse-operator-moccur-grep-find-key
                     'vimpulse-moccur-grep-find-region-operator)
(vimpulse-define-key 'vimpulse-operator-moccur-mode 'visual-state
                     vimpulse-operator-moccur-grep-find-key
                     'vimpulse-moccur-grep-find-region-operator)

;;;###autoload
(define-minor-mode vimpulse-operator-moccur-mode
  "Toggle activation of moccur operator key bind of Vimpulse."
  :lighter ""
  :group 'vimpulse-operator-moccur
  nil)

(defun vimpulse-operator-moccur-mode-install ()
  (vimpulse-operator-moccur-mode 1))

;;;###autoload
(define-globalized-minor-mode global-vimpulse-operator-moccur-mode
  vimpulse-operator-moccur-mode vimpulse-operator-moccur-mode-install)
(global-vimpulse-operator-moccur-mode)

(provide 'vimpulse-operator-moccur)
