(defgroup vimpulse-cjk nil
  "CJK patch for Viper/Vimpulse"
  :prefix "vimpulse-cjk-"
  :group 'vimpulse)

(defcustom vimpulse-cjk-want-japanese-phrase-as-word nil
  "Treats successive kanjis and hiraganas as a word.
This is rather Emacs behaviour than Vim."
  :type 'boolean
  :group 'vimpulse-cjk)

(defun viper-cjk-category (ch)
  (let ((cat (char-category-set ch))
        (list '(?K ; katakana
                ?A ; full-width alpha-numeric
                ?H ; hiragana
                ?C ; kanji
                ?k ; half-width kana
                ?j ; Japanese
                ?c ; Chinese
                ?h ; Korean
                )))
    (let (r) (dolist (x list r) (setq r (or r (when (aref cat x) x)))))))

(defun viper-cjk-category-after (pos)
  (and (< pos (point-max)) (viper-cjk-category (char-after pos))))

(defun viper-cjk-category-before (pos)
  (and (< (point-min) pos) (viper-cjk-category (char-before pos))))

(defun viper-looking-at-cjk ()
  (viper-cjk-category-after (point)))

(defun viper-skip-cjk-forward (&optional cat)
  (let ((cat (viper-cjk-category-after (point))))
    (when cat
      (while (= cat (or (viper-cjk-category-after (point)) 0))
        (forward-char)))))

(defun viper-skip-cjk-backward (&optional cat)
  (let ((cat (viper-cjk-category-after (point))))
    (when cat
      (while (= cat (or (viper-cjk-category-before (point)) 0))
        (backward-char)))))

(defadvice viper-looking-at-alpha
  (around ad-viper-looking-at-alpha-cjk activate)
  (or ad-do-it (and vimpulse-cjk-want-japanese-phrase-as-word
                    (viper-looking-at-cjk))))

(defadvice viper-skip-alpha-forward
  (around ad-viper-skip-alpha-forward-cjk (arg) activate)
  (let ((cjk (viper-looking-at-cjk)))
    (if (and cjk (not vimpulse-cjk-want-japanese-phrase-as-word))
        (viper-skip-cjk-forward)
      (forward-word))
    (when (and (not cjk) arg (looking-at arg))
      (forward-char)
      (when (viper-looking-at-alpha) (viper-skip-alpha-forward arg)))))

(defadvice viper-skip-alpha-backward
  (around ad-viper-skip-alpha-backward-cjk (arg) activate)
  (let ((cjk (viper-looking-at-cjk)))
    (if (and cjk (not vimpulse-cjk-want-japanese-phrase-as-word))
        (viper-skip-cjk-backward)
      (when (and (< (point-min) (point))
                 (save-excursion
                   (backward-char)
                   (and (not (viper-end-of-word-p))
                        (not (viper-looking-at-separator)))))
        (backward-word)))
    (when (and (not cjk)
               arg
               (< (point-min) (point))
               (string= (string (char-before (point))) arg))
      (backward-char)
      (when (and (< (point-min) (point))
                 (save-excursion (backward-char) (viper-looking-at-alpha)))
        (viper-skip-alpha-backward arg)))))

(defadvice viper-end-of-word-p
  (around ad-viper-end-of-word-p-cjk activate)
  (setq ad-return-value
        (or ad-do-it
            (if (viper-looking-at-cjk)
                (let ((cat1 (viper-cjk-category-after (point)))
                      (cat2 (save-excursion
                              (forward-char)
                              (or (viper-cjk-category-after (point)) 0))))
                  (and (not (= cat1 cat2))
                       (or (not vimpulse-cjk-want-japanese-phrase-as-word)
                           (not (= cat1 ?C))
                           (not (= cat2 0)))))
              (save-excursion (forward-char) (viper-looking-at-cjk))))))

(provide 'vimpulse-cjk)
