
(defun kill-this-line ()
  (move-beginning-of-line 1)
  (kill-line 1))

(defun same-tokensp (tokens)
  (equal (first tokens) (second tokens)))

(defun remove-trailing-spaces (line)
  (replace-regexp-in-string "[\n\t\r ]+$" "" line))

(defun remove-if-matches ()
  (interactive)
  (if (not (same-tokensp (split-string (remove-trailing-spaces (thing-at-point 'line)) ":? +")))
      (kill-this-line)
    (forward-line 1)))

;;; This should test if a buffer correspondes to a right test class,
;;; that is one with the right resource tester, with the right class
;;; name

(defun is-a-testp ()
  (save-excursion
    (and (search-forward "ResourceTester" nil t)
         (search-forward "newInstance" nil t))))

(defun class-from-buffer-name (buffer-name)
  (first (split-string (car (last (split-string buffer-name "\/"))) "[.]")))

(defun class-from-test-class (test-class-name)
  (replace-regexp-in-string "Test$" "" test-class-name))

(defun get-class-name ()
  (class-from-test-class
   (class-from-buffer-name (buffer-name))))

(defun contains-the-proper-stuffp ()
  (save-excursion
    (and (search-forward "newInstance" nil t)
         (search-forward "{")
         (search-forward-regexp (concat "new[ \t\r\n]+" (regexp-quote (get-class-name))) nil t))))

(defun right-test-classp ()
  (interactive)
  (if (is-a-testp)
      (if (contains-the-proper-stuffp)
          (message "Proper test class: rejoy!")
        (message "Not a proper test class (wrong content)"))
    (message "Not a proper test class (no resource test)")))



