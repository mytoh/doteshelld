;;; freebsd -*- lexical-binding: t; coding: utf-8; -*-

;;; Code:

(when (string-equal system-type "berkeley-unix")
  (eshellar:add-alias "pcheck" "sudo portmaster -PBiydav && sudo portaudit -Fdav && sudo portmaster --clean-packages --clean-distfiles" )
  (eshellar:add-alias "pfetch" "sudo make fetch-recursive" )
  (eshellar:add-alias "pinst" "sudo make -s clean reinstall clean distclean BATCH=yes")
  (eshellar:add-alias "pconf" "sudo make config")
  (eshellar:add-alias "pconfr" "sudo make config-recursive")
  (eshellar:add-alias "pclean" "sudo make clean "         )
  (eshellar:add-alias "ppconf" "make pretty-print-config" )
  (eshellar:add-alias "psconf" "make showconfig"          )
  (eshellar:add-alias "prmconf" "make rmconfig"           )
  (eshellar:add-alias "puniname" "make -VUNIQUENAME")
  (eshellar:add-alias "pm" "sudo portmaster -dBvy -m BATCH=yes"))

(eshellar:add-exec-path "~/.shellar_custom/bottles/freebsd/bin")

;;; freebsd.el ends here
