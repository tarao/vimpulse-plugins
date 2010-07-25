(defgroup vimpulse-comment-operator nil
  "Comment/uncomment operator for Vimpulse"
  :prefix "vimpulse-comment-operator-"
  :group 'vimpulse)

(defcustom vimpulse-comment-operator-key (kbd "C")
  "A key for comment/uncomment operator"
  :type `,(if (get 'key-sequence 'widget-type)
              'key-sequence
            'sexp)
  :group 'vimpulse-comment-operator)

(vimpulse-convert-to-operator 'comment-or-uncomment-region)
(vimpulse-define-key 'vimpulse-comment-operator-mode 'vi-state
                     vimpulse-comment-operator-key
                     'comment-or-uncomment-region-operator)
(vimpulse-define-key 'vimpulse-comment-operator-mode 'visual-state
                     vimpulse-comment-operator-key
                     'comment-or-uncomment-region-operator)

;;;###autoload
(define-minor-mode vimpulse-comment-operator-mode
  "Toggle activation of comment/uncomment operator key bind of Vimpulse."
  :lighter ""
  :group 'vimpulse-comment-operator
  nil)

(defun vimpulse-comment-operator-mode-install ()
  (vimpulse-comment-operator-mode 1))

;;;###autoload
(define-globalized-minor-mode global-vimpulse-comment-operator-mode
  vimpulse-comment-operator-mode vimpulse-comment-operator-mode-install)
(global-vimpulse-comment-operator-mode)

(provide 'vimpulse-comment-operator)
