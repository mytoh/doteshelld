;;; init -*- lexical-binding: t; coding: utf-8; -*-

;;; Code:

(when (locate-library "eshell-did-you-mean")
  (autoload #'eshell-did-you-mean-output-filter
      "eshell-did-you-mean")
  (add-to-list 'eshell-preoutput-filter-functions
               #'eshell-did-you-mean-output-filter))

;;; init.el ends here
