;;; alias -*- lexical-binding: t; coding: utf-8; -*-

;;; Code:

(eshellar:add-alias  "img" "insert-image ${create-image ${expand-file-name $1}} ")
(eshellar:add-alias "imgs" "insert-sliced-image ${create-image ${expand-file-name $1}}  ' ' () 60 1")
(eshellar:add-alias  "k" "killall -9 $*")
(eshellar:add-alias  "d" "dired-other-window ${pwd}")
(eshellar:add-alias  "ff" "find-file $1")
(eshellar:add-alias  "ll" "ls -l")
(eshellar:add-alias  "la" "ls -a")
(eshellar:add-alias  "tk" "talikko $*")
(eshellar:add-alias  "," "napa $*")
(eshellar:add-alias  "ag" "ag --nopager $*")
(eshellar:add-alias  "af" "ag --nopager -g $*")
(eshellar:add-alias  "pam" "rm -rf $*")
(eshellar:add-alias  "ke" "save-buffers-kill-emacs")
(eshellar:add-alias  "cde" "cd ~/.emacs.d/vendor/github.com/emacs-mirror/emacs")
(eshellar:add-alias  "gpl" "git pull --verbose")
(eshellar:add-alias  "gst" "git status")
(eshellar:add-alias  "kuva" "pikkukivi kuva $*")
(eshellar:add-alias  "ä" "pikkukivi ääliö $*")
(eshellar:add-alias  "get" "aria2c $*")
(eshellar:add-alias "ottaa" "mkdir -pv $1; cd $1")
(eshellar:add-alias "src" "kiitos service $*")
(eshellar:add-alias "qj" "kiitos qjail $*")

;;; alias.el ends here
