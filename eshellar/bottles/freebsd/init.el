;;; freebsd -*- lexical-binding: t; coding: utf-8; -*-

;;; Code:

(cl-defun muki:eshell-add-alias (name def)
  (add-to-list 'eshell-command-aliases-list (list name def)))

(when (string-equal system-type "berkeley-unix")
  (muki:eshell-add-alias "pcheck" "sudo portmaster -PBiydav && sudo portaudit -Fdav && sudo portmaster --clean-packages --clean-distfiles" )
  (muki:eshell-add-alias "pfetch" "sudo make fetch-recursive" )
  (muki:eshell-add-alias "pinst" "sudo make -s clean reinstall clean distclean BATCH=yes")
  (muki:eshell-add-alias "pconf" "sudo make config")
  (muki:eshell-add-alias "pconfr" "sudo make config-recursive")
  (muki:eshell-add-alias "pclean" "sudo make clean "         )
  (muki:eshell-add-alias "ppconf" "make pretty-print-config" )
  (muki:eshell-add-alias "psconf" "make showconfig"          )
  (muki:eshell-add-alias "prmconf" "make rmconfig"           )
  (muki:eshell-add-alias "puniname" "make -VUNIQUENAME"))


;;; freebsd.el ends here
