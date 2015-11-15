;;; init --- init -*- lexical-binding: t; coding: utf-8; -*-

;;; Commentary:

;;; Code:

(require 'esh-buf-stack)
(setup-eshell-buf-stack)
(add-hook 'eshell-mode-hook
          (lambda ()
            (local-set-key
             (kbd "M-q") 'eshell-push-command)))

;;; init.el ends here
