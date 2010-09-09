(defgroup vimpulse-operator-comment nil
  "Comment/uncomment operator for Vimpulse"
  :prefix "vimpulse-operator-comment-"
  :group 'vimpulse)

(defcustom vimpulse-operator-comment-key (kbd "C")
  "A key for comment/uncomment operator"
  :type `,(if (get 'key-sequence 'widget-type)
              'key-sequence
            'sexp)
  :group 'vimpulse-operator-comment)

(vimpulse-convert-to-operator comment-or-uncomment-region)
(vimpulse-define-key 'vimpulse-operator-comment-mode 'vi-state
                     vimpulse-operator-comment-key
                     'comment-or-uncomment-region-operator)
(vimpulse-define-key 'vimpulse-operator-comment-mode 'visual-state
                     vimpulse-operator-comment-key
                     'comment-or-uncomment-region-operator)

;;;###autoload
(define-minor-mode vimpulse-operator-comment-mode
  "Toggle activation of comment/uncomment operator key bind of Vimpulse."
  :lighter ""
  :group 'vimpulse-operator-comment
  nil)

(defun vimpulse-operator-comment-mode-install ()
  (vimpulse-operator-comment-mode 1))

;;;###autoload
(define-globalized-minor-mode global-vimpulse-operator-comment-mode
  vimpulse-operator-comment-mode vimpulse-operator-comment-mode-install)
(global-vimpulse-operator-comment-mode)

(provide 'vimpulse-operator-comment)
