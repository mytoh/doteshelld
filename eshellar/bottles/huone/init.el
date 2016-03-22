;;; init -*- lexical-binding: t; coding: utf-8; -*-

;;; Code:

;; (setenv "HUONE" (expand-file-name "~/huone"))

(cl-defun set-exec-path-from-shell-PATH (shell env)
  (cl-letf* ((option (cond ((string-match-p "tcsh\\'" shell)
                            "-c")
                           ((string-match-p "mksh\\'" shell)
                            "-l -c")
                           ((string-match-p "fish\\'" shell)
                            (concat "--interactive --login --command=\"printf '%s' "
                                    " {$" env "} " "\""))
                           ;; fish -i -l -c "printf \"__RESULT %s %s\" \"$PATH\" \"$MANPATH\""
                           (else
                            "--login -c")))
             (env-value-from-shell (replace-regexp-in-string
                                    "[ \t\n]*$" ""
                                    (shell-command-to-string (concat shell " " option " 'echo $"
                                                                     env "'")))))
    (setenv env env-value-from-shell)
    (if (string-equal env "PATH")
        (setq exec-path (split-string env-value-from-shell path-separator)))))

(colle:each
 (lambda (env)
   (set-exec-path-from-shell-PATH (getenv "SHELL")
                                  env))
 '("PATH" "HUONE" "HUONE_OHJELMAT"))


;;; init.el ends here
