(defgroup vimpulse-textobj-between nil
  "Text object between for Vimpulse"
  :prefix "vimpulse-textobj-between-"
  :group 'vimpulse)

(defcustom vimpulse-textobj-between-i-key '("ib")
  "Keys for vimpulse-inner-between"
  :type '(string)
  :group 'vimpulse-textobj-between)
(defcustom vimpulse-textobj-between-a-key '("ab")
  "Keys for vimpulse-a-between"
  :type '(string)
  :group 'vimpulse-textobj-between)

(defun enable-advice-and-activate (function class name)
  (ad-enable-advice function class name)
  (ad-activate function))
(defun disable-advice-and-activate (function class name)
  (ad-disable-advice function class name)
  (ad-activate function))
(defmacro locally-enable-advice (function class name &rest body)
  (declare (indent 3))
  `(unwind-protect
       (progn
         (enable-advice-and-activate ,function ,class ,name)
         ,@body)
     (disable-advice-and-activate ,function ,class ,name)))

(defadvice scan-sexps (around ad-fake-scan-sexps (from count) activate)
  (setq ad-return-value (if (= from beg) end beg)))
(disable-advice-and-activate 'scan-sexps 'around 'ad-fake-scan-sexps)

(defun vimpulse-between-range (arg &optional include)
  (condition-case ()
      (let ((ch (read-char)))
        (when (string ch)
          (locally-enable-advice 'scan-sexps 'around 'ad-fake-scan-sexps
            (vimpulse-quote-range arg ch include))))))

(eval
 `(vimpulse-define-text-object vimpulse-inner-between (arg)
    "Select inner range between a character by which the command is followed."
    :keys ,vimpulse-textobj-between-i-key
    (vimpulse-between-range arg)))
(eval
 `(vimpulse-define-text-object vimpulse-a-between (arg)
    "Select range between a character by which the command is followed."
    :keys ,vimpulse-textobj-between-a-key
    (vimpulse-between-range arg t)))

(provide 'vimpulse-textobj-between)
