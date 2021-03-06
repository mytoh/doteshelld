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
(eshellar:add-alias  "ag" "ag $*")
(eshellar:add-alias  "af" "ag -g $*")
(eshellar:add-alias  "pam" "rm -rf $*")
(eshellar:add-alias  "ke" "save-buffers-kill-emacs")
;; (eshellar:add-alias  "cde" "cd ~/.emacs.d/vendor/github.com/emacs-mirror/emacs")
(eshellar:add-alias  "cde" "cd ~/.emacs.d/vendor/git.sv.gnu.org/emacs.git")
(eshellar:add-alias  "gpl" "git pull --verbose --ff --ff-only --update-shallow")
(eshellar:add-alias  "gst" "git status")
(eshellar:add-alias  "kuva" "pikkukivi kuva $*")
(eshellar:add-alias  "ä" "pikkukivi ääliö $*")
(eshellar:add-alias  "get" "aria2c $*")
(eshellar:add-alias "ottaa" "mkdir -pv $1; cd $1")
(eshellar:add-alias "src" "kiitos service $*")
(eshellar:add-alias "qj" "kiitos qjail $*")
;; [[https://www.reddit.com/r/commandline/comments/4o22ot/any_os_with_mpva_pip_implementation_like_the_one/][{Any Os with MPV}A PiP implementation like the one at apple wwdc yesterday us...]]
(eshellar:add-alias "vidpin" "mpv --ontop --on-all-workspaces --no-border --autofit=384x216 --geometry=99%:2% $*")
(eshellar:add-alias "paths" "printnl {split-string $PATH \":\"}")
(eshellar:add-alias "lpaths" "printnl $load-path")
(eshellar:add-alias "df" "df -h")
(eshellar:add-alias "ll" "ls -lh")
(eshellar:add-alias "la" "ls -a")

(eshellar:add-alias "font-view" "fc-match '$1' -f '%{file}' | xargs display")

;;; alias.el ends here
