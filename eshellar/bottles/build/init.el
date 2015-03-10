;;; build -*- lexical-binding: t; coding: utf-8; -*-

;;; Code:

(cl-defun muki:eshell-define-build-alias
    (&key alias repo commands)
  (eshellar:add-alias alias
                      (concat "cd ~/huone/git/" repo
                              "; "
                              (string-join commands " "))))

(cl-defun eshell/link-emacs ()
  (seq-each
   (lambda (b)
     (make-symbolic-link
      (concat "~/huone/ohjelmat/" "emacs" "/bin/" b)
      (concat "~/huone/työkaluvaja/bin/" b)
      'OK-IF-ALREADY-EXISTS))
   '("ctags"  "ebrowse"  "emacs"  "emacs-25.0.50"  "emacsclient"  "etags")))

(cl-defun eshell/link-emacs-new ()
  (seq-each
   (lambda (b)
     (make-symbolic-link
      (concat "~/huone/ohjelmat/" "emacs-new" "/bin/" b)
      (concat "~/huone/työkaluvaja/bin/" b)
      'OK-IF-ALREADY-EXISTS))
   '("ctags"  "ebrowse"  "emacs"  "emacs-25.0.50"  "emacsclient"  "etags")))


(cl-letf* ((clang-devel "CC=clang-devel")
           (clang35 "CC=clang35")
           (gcc "CC=gcc5")
           (compiler clang35)
           (xwidgets "--with-xwidgets")
           (x-gtk3 "--with-x-toolkit=gtk3")
           (x-no  "--with-x-toolkit=no")
           (x-motif  "--with-x-toolkit=motif")
           (x-athena  "--with-x-toolkit=athena")
           (x-xaw3d  "--with-x-toolkit=athena --without-xaw3d")
           (xtoolkit x-no)
           (cflags "CFLAGS=\"-O2 -pipe -fstack-protector -fno-strict-aliasing\"")
           (build-emacs-configure-options
            (list
             "--prefix=/home/mytoh/huone/ohjelmat/emacs"
             "--disable-acl"
             "--with-sound=oss"
             xwidgets
             xtoolkit
             "--with-wide-int"
             "--with-file-notification=gfile"
             "--enable-link-time-optimization"
             "--enable-silent-rules"
             "--without-compress-install"
             "--without-toolkit-scroll-bars"
             "--without-xim"
             compiler
             cflags
             "MAKE=gmake")))
  (muki:eshell-define-build-alias
   :alias "build-emacs"
   :repo "git.savannah.gnu.org/emacs"
   :commands
   `("cde; gpl; gmake clean distclean; ./autogen.sh ;"
     "./configure "
     ,@build-emacs-configure-options
     "; gmake V=0 --silent && gmake install; gmake clean distclean"))
  (eshellar:add-alias "build-emacs-bootstrap"
                      (string-join
                       `("cde; gpl; gmake clean distclean; ./autogen.sh ;"
                         "./configure"
                         ,@build-emacs-configure-options
                         "; gmake V=0 bootstrap && gmake install; gmake clean distclean")
                       " ")))

(cl-letf* ((clang-devel "CC=clang-devel")
           (clang35 "CC=clang35")
           (gcc "CC=gcc5")
           (compiler clang35)
           (xwidgets "--with-xwidgets")
           (x-gtk3 "--with-x-toolkit=gtk3")
           (x-no  "--with-x-toolkit=no")
           (x-motif  "--with-x-toolkit=motif")
           (x-athena  "--with-x-toolkit=athena")
           (x-xaw3d  "--with-x-toolkit=athena --without-xaw3d")
           (xtoolkit x-no)
           (cflags "CFLAGS=\"-O2 -pipe -fstack-protector -fno-strict-aliasing\"")
           (build-emacs-configure-options
            (list
             "--prefix=/home/mytoh/huone/ohjelmat/emacs-new"
             "--disable-acl"
             "--with-sound=oss"
             xwidgets
             xtoolkit
             "--with-wide-int"
             "--with-file-notification=gfile"
             "--enable-link-time-optimization"
             "--enable-silent-rules"
             "--without-compress-install"
             "--without-toolkit-scroll-bars"
             "--without-xim"
             compiler
             cflags
             "MAKE=gmake")))
  (muki:eshell-define-build-alias
   :alias "build-emacs-new"
   :repo "git.savannah.gnu.org/emacs"
   :commands
   `("gpl; gmake clean distclean; ./autogen.sh ;"
     "./configure "
     ,@build-emacs-configure-options
     "; gmake V=0 --silent && gmake install; gmake clean distclean")))


(eshellar:add-alias "build-gauche" " cd /home/mytoh/huone/git/github.com/shirok/Gauche && git pull ;gmake clean distclean; ./DIST gen && ./configure --prefix=/home/mytoh/huone/ohjelmat/gauche --enable-tls=axtls --with-local=/usr/local --enable-ipv6 CC=clang-devel CPP=clang-cpp-devel CXX=clang++-devel CFLAGS=\"-O2 -pipe -fstack-protector -fno-strict-aliasing\" && gmake all install")
(eshellar:add-alias "build-fish" "cd ~/huone/git/github.com/fish-shell/fish-shell ; git pull ; gmake clean distclean ; autoconf ; ./configure --prefix=/home/mytoh/huone/ohjelmat/fish LDFLAGS=-L/usr/local/lib CPPFLAGS=-I/usr/local/include CC=clang-devel CXX=clang++-devel CPP=clang-cpp-devel --with-doxygen ; gmake ; gmake install")
(eshellar:add-alias "build-stumpwm" "cd ~/huone/git/github.com/stumpwm/stumpwm ; gmake clean distclean ; ./autogen.sh ; ./configure --prefix=/home/mytoh/huone/ohjelmat/stumpwm && gmake && gmake install")
(eshellar:add-alias "build-mksh" "cd ~/huone/git/github.com/MirBSD/mksh && git pull ; env CC=clang-devel sh ./Build.sh -r -c lto ; cp -fv mksh ~/huone/ohjelmat/mksh/bin/mksh ; cp -fv mksh.1 ~/huone/ohjelmat/mksh/share/man/man1/mksh.1")
(eshellar:add-alias "build-tmux"
                    "cd ~/huone/git/git.code.sf.net/p/tmux/tmux-code ; git pull ; make clean distclean ; ./autogen.sh ; ./configure --prefix=/home/mytoh/huone/ohjelmat/tmux CC=clang-devel CPP=clang-cpp-devel CXX=clang++-devel && make && make install" )
(eshellar:add-alias "build-sxiv"
                    "cd ~/huone/git/github.com/muennich/sxiv/ ; git pull ; gmake clean ; gmake ; gmake PREFIX=\"~/huone/ohjelmat/sxiv\" install")

(muki:eshell-define-build-alias
 :alias "build-pandoc"
 :repo "github.com/jgm/pandoc"
 :commands
 '("cabal update;"
   "cabal install cabal-install;"
   "git pull;"
   "cabal clean;"
   "cabal install"))

(muki:eshell-define-build-alias
 :alias "build-feh"
 :repo "github.com/derf/feh"
 :commands
 '("gmake clean ; /usr/bin/env PREFIX=/home/mytoh/huone/ohjelmat/feh LDFLAGS=-L/usr/local/lib CFLAGS='-I/usr/local/include -I/usr/local/include/libpng16' exif=1 gmake  ; gmake install ; gmake clean"))

(muki:eshell-define-build-alias
 :alias "build-rofi"
 :repo "github.com/DaveDavenport/rofi"
 :commands
 '("autoreconf -i;"
   "rm -rfv build;"
   "mkdir -pv build;"
   " cd build;"
   " ../configure --prefix=/home/mytoh/huone/ohjelmat/rofi CC=clang-devel;"
   " gmake;"
   " gmake install;"))

(muki:eshell-define-build-alias
 :alias "build-youtube-dl"
 :repo "github.com/rg3/youtube-dl"
 :commands
 '("git pull;"
   " gmake clean;"
   " gmake PREFIX=/home/mytoh/huone/ohjelmat/youtube-dl install"))

(muki:eshell-define-build-alias
 :alias "build-bspwm"
 :repo "github.com/baskerville/bspwm"
 :commands
 '("git pull ;"
   "/usr/bin/env PREFIX=/home/mytoh/huone/ohjelmat/bspwm CFLAGS=-I/usr/local/include LDFLAGS=-L/usr/local/lib gmake clean all install"))


(muki:eshell-define-build-alias
 :alias "build-sxhkd"
 :repo "github.com/baskerville/sxhkd"
 :commands
 '("git pull ;"
   "/usr/bin/env PREFIX=/home/mytoh/huone/ohjelmat/sxhkd CFLAGS=-I/usr/local/include LDFLAGS=-L/usr/local/lib gmake clean all install"))

(muki:eshell-define-build-alias
 :alias "build-xtitle"
 :repo "github.com/baskerville/xtitle"
 :commands
 '("git pull;"
   "gmake LDFLAGS=-L/usr/local/lib CFLAGS='-std=c99 -I/usr/local/include -D_POSIX_C_SOURCE=200112L -DVERSION=0.1' PREFIX=/home/mytoh/huone/ohjelmat/xtitle  clean all install clean"))

(muki:eshell-define-build-alias
 :alias "build-youtube-dl"
 :repo "github.com/rg3/youtube-dl"
 :commands
 '("git pull;"
   "gmake;"
   "python ./setup.py install --user"))

;; cd ~/huone/git/github.com/knopwob/dunst/ ; gmake clean ; gmake PREFIX=/home/mytoh/huone/ohjelmat/dunst install

;;; build.el ends here
