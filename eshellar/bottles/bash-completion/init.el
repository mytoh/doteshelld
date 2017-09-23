;;; init -- init -*- lexical-binding: t; coding: utf-8; -*-

;;; Commentary:

;;; Code:

;; [[https://github.com/szermatt/emacs-bash-completion/issues/13][Extend to work in sh-mode · Issue #13 · szermatt/emacs-bash-completion · GitHub]]
;; [[https://github.com/Ambrevar/dotfiles/blob/master/.emacs.d/lisp/init-eshell.el][dotfiles/init-eshell.el at master · Ambrevar/dotfiles · GitHub]]

(when (require 'bash-completion nil t)
  (defun eshell-bash-completion ()
    (while (pcomplete-here
            (nth 2 (bash-completion-dynamic-complete-nocomint (save-excursion (eshell-bol) (point)) (point))))))
  ;; Sometimes `eshell-default-completion-function' does better, e.g. "gcc
  ;; <TAB>" shows .c files.
  (setq eshell-default-completion-function #'eshell-bash-completion))



;;; init.el ends here
