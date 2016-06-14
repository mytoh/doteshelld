;;; init -*- lexical-binding: t; coding: utf-8; -*-

;;; Code:

(eshellar:add-alias "clip"
                    "xclip -o")

(eshellar:add-alias "clip-base"
                    "xclip -o | xargs basename")

(eshellar:add-alias "clip-yotsuba"
                    "clip | xargs dirname | xargs basename | xargs mkdir -pv")
(eshellar:add-alias "clip-futaba"
                    "clip | xargs basename | xargs -I% basename % .htm | xargs mkdir -pv")

;;; init.el ends here
