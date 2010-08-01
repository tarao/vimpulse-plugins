(defun viper-looking-at-cjk ()
  (let ((pos (point)))
    (when (< pos (point-max))
      (let* ((ch (char-after pos))
             (cat (char-category-set ch)))
        (or (aref cat ?c) ; Chinese
            (aref cat ?j) ; Japanese
            (aref cat ?h) ; Korean
            )))))
(defadvice viper-looking-at-alpha
  (around ad-viper-looking-at-alpha-cjk activate)
  (or ad-do-it (viper-looking-at-cjk)))
(defadvice viper-skip-alpha-forward
  (around ad-viper-skip-alpha-forward (arg) activate)
  (forward-word)
  (when (and arg (looking-at arg))
    (forward-char)
    (when (viper-looking-at-alpha) (viper-skip-alpha-forward arg))))
(defadvice viper-skip-alpha-backward
  (around ad-viper-skip-alpha-backward (arg) activate)
  (backward-word)
  (when (and (< (point-min) (point))
             (string= (string (char-before (point))) (or arg "")))
    (backward-char)
    (when (and (< (point-min) (point))
               (save-excursion (backward-char) (viper-looking-at-alpha)))
      (viper-skip-alpha-backward arg))))

(provide 'vimpulse-cjk)
