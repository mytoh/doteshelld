;;; option -*- lexical-binding: t; coding: utf-8; -*-

;;; Code:


;; (or (getenv "CDPATH")
;; (setenv "CDPATH"
;;         (cl-reduce
;;                                            (lambda (a b)
;;      (cl-concatenate 'string
;;      (expand-file-name a) ":" (expand-file-name b)))
;;   '("~/huone" "~"  "/usr/local"))))

(setenv "PAGER" "cat")
(setenv "TERM" "dumb")
;; (setenv "TERM" "xterm-256color")

;; 補完時に大文字小文字を区別しない
(setq eshell-cmpl-ignore-case t)

;; 補完時にサイクルする
(setq eshell-cmpl-cycle-completions t)

;; 補完候補がこの数値以下だとサイクルせずに候補表示
(setq eshell-cmpl-cycle-cutoff-length 5)

;; 履歴で重複を無視する
(setq eshell-hist-ignoredups t)

;; scroll to the bottom
(setq eshell-scroll-to-bottom-on-output nil)
(setq eshell-scroll-show-maximum-output t)

;; glob
(setq eshell-glob-case-insensitive t)
(setq eshell-glob-include-dot-dot nil)

;; history
(setq eshell-history-size 100000)

;; The maximum size in lines for eshell buffers.
(setq eshell-buffer-maximum-lines (* 1024 10))

;; run ls after cd
(setq eshell-list-files-after-cd t)

;; directory ring size
(setq eshell-last-dir-ring-size 500)


;; evil
(liby 'evil

  ;; helm
  (liby 'helm
    (evil-define-key 'insert eshell-mode-map (kbd "C-r") 'helm-eshell-history)
    (add-key eshell-mode-map [remap eshell-pcomplete]  'helm-esh-pcomplete))

  (liby 'helm-eshell-jump
    (autoload 'helm-eshell-jump "helm-eshell-jump")
    (evil-define-key 'insert eshell-mode-map (kbd "C-z") 'helm-eshell-jump))

  (evil-define-key 'insert eshell-mode-map (kbd "C-p") 'eshell-previous-matching-input-from-input)
  (evil-define-key 'insert eshell-mode-map (kbd "C-n") 'eshell-next-matching-input-from-input)
  (evil-define-key 'normal eshell-mode-map (kbd "C-p") 'eshell-previous-prompt)
  (evil-define-key 'normal eshell-mode-map (kbd "C-n") 'eshell-next-prompt))

;; (define-key eshell-mode-map (kbd "C-r") #'eshell-previous-matching-input-from-input)
(add-to-list 'eshell-visual-commands "ssh")
(add-to-list 'eshell-visual-commands "tail")
(add-to-list 'eshell-visual-commands "lv")
(add-to-list 'eshell-command-completions-alist
             `("unarchive.sh" . ,(concat (regexp-opt '(".tar" ".tgz" ".tar.gz" ".txz" ".tar.xz" ".cbz" ".cbr" ".cbx"
                                                       ".rar" ".zip" ".7z"))
                                         "\\'")))
(add-to-list 'eshell-output-filter-functions 'eshell-handle-ansi-color)
(add-to-list 'eshell-output-filter-functions 'eshell-truncate-buffer)
(add-to-list 'eshell-output-filter-functions 'eshell-postoutput-scroll-to-bottom)

;;; option.el ends here
