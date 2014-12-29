;;; build -*- lexical-binding: t; coding: utf-8; -*-

;;; Code:

(cl-defun muki:eshell-define-build-alias (name repo &rest commands)
  (declare (indent 2))
  (eshellar:add-alias name
                      (concat "cd ~/huone/git/" repo
                              "; "
                              (string-join commands " "))))


(cl-letf* ((clang-devel "CC=clang-devel")
           (clang35 "CC=clang35")
           (gcc "CC=gcc5")
           (compiler clang35)
           (cflags "CFLAGS=\"-O2 -pipe -fstack-protector -fno-strict-aliasing\"")
           (build-emacs-configure-options
            (list
             "--prefix=/home/mytoh/huone/ohjelmat/emacs"
             "--disable-acl"
             "--with-sound=oss"
             "--with-x-toolkit=motif"
             ;; "--with-x-toolkit=gtk3"
             ;; "--with-x-toolkit=athena"
             ;; "--with-x-toolkit=athena --without-xaw3d"
             "--with-wide-int"
             "--with-file-notification=gfile"
             "--enable-link-time-optimization"
             "--enable-silent-rules"
             "--without-compress-install"
             "--without-toolkit-scroll-bars"
             compiler
             cflags
             "MAKE=gmake")))
  (eshellar:add-alias "build-emacs"
                      (string-join
                       `("cde; gpl; gmake clean distclean; ./autogen.sh ;"
                         "./configure"
                         ,@build-emacs-configure-options
                         "; gmake V=0 --silent && gmake install; gmake clean distclean")
                       " "))
  (eshellar:add-alias "build-emacs-bootstrap"
                      (string-join
                       `("cde; gpl; gmake clean distclean; ./autogen.sh ;"
                         "./configure"
                         ,@build-emacs-configure-options
                         "; gmake V=0 bootstrap && gmake --silent && gmake install; gmake clean distclean")
                       " ")))
(eshellar:add-alias "build-gauche" " cd /home/mytoh/huone/git/github.com/shirok/Gauche && git pull ; ./DIST gen && ./configure --prefix=/home/mytoh/huone/ohjelmat/gauche --enable-tls=axtls --with-local=/usr/local --enable-ipv6 CC=clang-devel CPP=clang-cpp-devel CXX=clang++-devel CFLAGS=\"-O2 -pipe -fstack-protector -fno-strict-aliasing\" && gmake all install")
(eshellar:add-alias "build-fish" "cd ~/huone/git/github.com/fish-shell/fish-shell ; git pull ; gmake clean distclean ; autoconf ; ./configure --prefix=/home/mytoh/huone/ohjelmat/fish LDFLAGS=-L/usr/local/lib CPPFLAGS=-I/usr/local/include CC=clang-devel CXX=clang++-devel CPP=clang-cpp-devel --with-doxygen ; gmake ; gmake install")
(eshellar:add-alias "build-stumpwm" "cd ~/huone/git/github.com/stumpwm/stumpwm ; gmake clean distclean ; ./autogen.sh ; ./configure --prefix=/home/mytoh/huone/ohjelmat/stumpwm && gmake && gmake install")
(eshellar:add-alias "build-mksh" "cd ~/huone/git/github.com/MirBSD/mksh && git pull ; env CC=clang-devel sh ./Build.sh -r -c lto ; cp -fv mksh ~/huone/ohjelmat/mksh/bin/mksh ; cp -fv mksh.1 ~/huone/ohjelmat/mksh/share/man/man1/mksh.1")
(eshellar:add-alias "build-tmux"
                    "cd ~/huone/git/git.code.sf.net/p/tmux/tmux-code ; git pull ; make clean distclean ; ./autogen.sh ; ./configure --prefix=/home/mytoh/huone/ohjelmat/tmux CC=clang-devel CPP=clang-cpp-devel CXX=clang++-devel && make && make install" )
(eshellar:add-alias "build-sxiv"
                    "cd ~/huone/git/github.com/muennich/sxiv/ ; git pull ; gmake clean ; gmake ; gmake PREFIX=\"~/huone/ohjelmat/sxiv\" install")

(muki:eshell-define-build-alias "build-pandoc" "github.com/jgm/pandoc"
  "cabal update;"
  "cabal install cabal-install;"
  "git pull;"
  "cabal clean;"
  "cabal install")

(muki:eshell-define-build-alias "build-feh" "github.com/derf/feh"
  "gmake clean ; /usr/bin/env PREFIX=/home/mytoh/huone/ohjelmat/feh LDFLAGS=-L/usr/local/lib CFLAGS='-I/usr/local/include -I/usr/local/include/libpng16' exif=1 gmake  ; gmake install ; gmake clean"
  )


;; cd ~/huone/git/github.com/knopwob/dunst/ ; gmake clean ; gmake PREFIX=/home/mytoh/huone/ohjelmat/dunst install

;;; build.el ends here
