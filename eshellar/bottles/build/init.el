;;; build -*- lexical-binding: t; coding: utf-8; -*-

;;; Code:

(cl-defun muki:build-path-huone-git (path)
  (thread-last (getenv "HUONE")
    (expand-file-name "git")
    (expand-file-name path)))

(cl-defun muki:build-path-hoarder (path)
  (expand-file-name path
                    hoarder-directory))



(cl-defun muki:eshell-define-build-alias
    (&key alias repo commands notify bin)
  (eshellar:add-alias alias
                      (concat "cd "
                              repo
                              "; "
                              (string-join commands " ")
                              (if notify
                                  (seq-concatenate 'string
                                                   ";"
                                                   "(notifications-notify :title "
                                                   "\"eshell\""
                                                   " :body "
                                                   "\"finished " alias "\" "
                                                   " :urgency 'low :x 1100 :y 100 :timeout -1)")
                                ""))))

(cl-defun eshell/link-emacs ()
  (seq-each
   (lambda (b)
     (make-symbolic-link
      (expand-file-name (concat "ohjelmat/emacs/bin/" b) 
                        (getenv "HUONE"))
      (expand-file-name (concat "työkaluvaja/bin/" b)
                        (getenv "HUONE"))
      'OK-IF-ALREADY-EXISTS))
   '("ctags"  "ebrowse"  "emacs"  "emacsclient"  "etags")))

(cl-defun eshell/link-emacs-new ()
  (seq-each
   (lambda (b)
     (make-symbolic-link
      (expand-file-name (concat "ohjelmat/emacs-new/bin/" b)
                        (getenv "HUONE"))
      (expand-file-name (concat "työkaluvaja/bin/" b)
                        (getenv "HUONE"))
      'OK-IF-ALREADY-EXISTS))
   '("ctags"  "ebrowse"  "emacs"  "emacsclient"  "etags")))


(cl-letf* ((clang-devel "CC=clang-devel")
           (clang35 "CC=clang35")
           (gcc "CC=gcc6")
           (compiler clang-devel)
           (cairo "--without-cairo")
           (xwidgets "--with-xwidgets")
           (x-gtk3 "--with-x-toolkit=gtk3")
           (x-no  "--with-x-toolkit=no")
           (x-motif  "--with-x-toolkit=motif")
           (x-athena  "--with-x-toolkit=athena")
           (x-xaw3d  "--with-x-toolkit=athena --without-xaw3d")
           (xtoolkit x-no)
           (cflags "CFLAGS='-O2'")
           (prefix (concat "--prefix="
                           (expand-file-name "ohjelmat/emacs" (getenv "HUONE"))
                           " "))
           (prefix-new (concat "--prefix="
                               (expand-file-name "ohjelmat/emacs-new" (getenv "HUONE"))
                               " "))
           (build-emacs-configure-options
            (list
             "--disable-acl"
             "--with-sound=oss"
             ;; xwidgets
             xtoolkit
             cairo
             "--with-wide-int"
             ;; "--with-file-notification=gfile"
             "--enable-link-time-optimization"
             "--enable-silent-rules"
             "--without-compress-install"
             "--without-toolkit-scroll-bars"
             "--without-xim"
             ;; "--without-gconf"
             ;; "--without-gsettings"
             ;; "--with-file-notification=kqueue"
             "--with-modules"
             compiler
             cflags
             "MAKE=gmake")))
  (muki:eshell-define-build-alias
   :alias "build-emacs"
   :repo (muki:build-path-hoarder "github.com/emacs-mirror/emacs")
   :commands
   `("gpl; gmake clean distclean; ./autogen.sh all;"
     "rm -fv build;"
     "mkdir -pv build;"
     "cd build;"
     "../configure "
     ,prefix 
     ,@build-emacs-configure-options
     "; gmake V=0 --silent && gmake install; gmake clean distclean"))
  (muki:eshell-define-build-alias
   :alias "build-emacs-new"
   :repo (muki:build-path-hoarder "github.com/emacs-mirror/emacs")
   :commands
   `("gpl; gmake clean distclean; ./autogen.sh all;"
     "rm -fv build;"
     "mkdir -pv build;"
     "cd build;"
     "../configure "
     ,prefix-new
     ,@build-emacs-configure-options
     "; gmake V=0 --silent && gmake install; gmake clean distclean"))
  (eshellar:add-alias "build-emacs-bootstrap"
                      (string-join
                       `("cde; gpl; gmake clean distclean; ./autogen.sh ;"
                         "./configure"
                         ,@build-emacs-configure-options
                         "; gmake V=0 bootstrap && gmake install; gmake clean distclean")
                       " ")))

(muki:eshell-define-build-alias
 :alias "build-tmux"
 :repo (muki:build-path-hoarder "github.com/tmux/tmux")
 :commands
 `("git pull;"
   "make clean distclean;"
   "./autogen.sh;"
   ,(concat "./configure --prefix="
            (expand-file-name "tmux" (getenv "HUONE_OHJELMAT"))
            " CC=clang-devel CPP=clang-cpp-devel CXX=clang++-devel;")
   "make;"
   "make install"))
(eshellar:add-alias "build-sxiv"
                    "cd ~/huone/git/github.com/muennich/sxiv/ ; git pull ; gmake clean ; gmake CC=clang-devel CPPFLAGS=-I/usr/local/include LDFLAGS=-L/usr/local/lib ; gmake PREFIX=\"~/huone/ohjelmat/sxiv\" install")
(eshellar:add-alias "build-mlterm"
                    "cd ~/huone/hg/mlterm/; hg pull; hg update; gmake distclean clean; ./configure --enable-utmp --enable-optimize-redrawing --enable-m17lib --with-gtk=3.0 --enable-sixel --prefix=/home/mytoh/huone/ohjelmat/mlterm; gmake; gmake install")

(muki:eshell-define-build-alias
 :alias "build-pandoc"
 :repo (muki:build-path-hoarder "github.com/jgm/pandoc")
 :commands
 '("cabal update;"
   "cabal install cabal-install;"
   "git pull;"
   "cabal clean;"
   "cabal install"))

(muki:eshell-define-build-alias
 :alias "build-feh"
 :repo (muki:build-path-hoarder "github.com/derf/feh")
 :commands
 `("gmake CPPFLAGS=-I/usr/local/include LDFLAGS=-L/usr/local/lib"
   ,(concat "  PREFIX="
            (expand-file-name "ohjelmat/feh"
                              (getenv "HUONE")))
   " clean all install"))

(muki:eshell-define-build-alias
 :alias "build-rofi"
 :repo (muki:build-path-hoarder "github.com/DaveDavenport/rofi")
 :commands
 '("git pull ;"
   "git submodule update --init ;"
   "gmake distclean ;"
   "autoreconf -i ;"
   "./configure --prefix=/home/mytoh/huone/ohjelmat/rofi CC=clang-devel &&"
   "gmake &&"
   "gmake install"))

(muki:eshell-define-build-alias
 :alias "build-bspwm"
 :repo (muki:build-path-hoarder "github.com/baskerville/bspwm")
 :commands
 '("git pull ;"
   "/usr/bin/env PREFIX=/home/mytoh/huone/ohjelmat/bspwm CFLAGS=-I/usr/local/include LDFLAGS=-L/usr/local/lib gmake clean all install"))


(muki:eshell-define-build-alias
 :alias "build-sxhkd"
 :repo (muki:build-path-hoarder "github.com/baskerville/sxhkd")
 :commands
 '("git pull ;"
   "/usr/bin/env PREFIX=/home/mytoh/huone/ohjelmat/sxhkd CFLAGS=-I/usr/local/include LDFLAGS=-L/usr/local/lib gmake clean all install"))

(muki:eshell-define-build-alias
 :alias "build-xtitle"
 :repo (muki:build-path-hoarder "github.com/baskerville/xtitle")
 :commands
 '("git pull;"
   "gmake LDFLAGS=-L/usr/local/lib CFLAGS='-std=c99 -I/usr/local/include -D_POSIX_C_SOURCE=200112L -DVERSION=0.1' PREFIX=/home/mytoh/huone/ohjelmat/xtitle  clean all install clean"))

(muki:eshell-define-build-alias
 :alias "build-youtube-dl"
 :repo (muki:build-path-hoarder "github.com/rg3/youtube-dl")
 :commands
 '("git pull;"
   "gmake;"
   "python3 ./setup.py clean install --user"))

(muki:eshell-define-build-alias
 :alias "build-sbcl"
 :repo (muki:build-path-hoarder "github.com/sbcl/sbcl")
 :commands
 `("git pull;"
   "echo '\"1.0.99.999\"' > version.lisp-expr;"
   ,(seq-concatenate 'string
                     "export SBCL_HOME="
                     (if (file-exists-p (expand-file-name "ohjelmat/sbcl/lib/sbcl"
                                                          (getenv "HUONE")))
                         (expand-file-name "ohjelmat/sbcl/lib/sbcl"
                                           (getenv "HUONE"))
                       "/usr/local/lib/sbcl")
                     ";")
   "sh make.sh --fancy;"
   ,(seq-concatenate 'string
                     "export INSTALL_ROOT="
                     (expand-file-name "ohjelmat/sbcl"
                                       (getenv "HUONE"))
                     ";"
                     (if (file-exists-p (expand-file-name "ohjelmat/sbcl/lib/sbcl"
                                                          (getenv "HUONE")))
                         ""
                       "unset SBCL_HOME;"))
   "sh install.sh;"
   "unset INSTALL_ROOT"))

(muki:eshell-define-build-alias
 :alias "build-mksh"
 :repo (muki:build-path-hoarder "github.com/MirBSD/mksh")
 :commands
 '("git pull ;"
   " env CC=gcc6 sh ./Build.sh -r -c lto ;"
   "mkdir -pv ~/huone/ohjelmat/mksh/bin ;"
   " cp -fv mksh ~/huone/ohjelmat/mksh/bin/mksh ;"
   "mkdir -pv ~/huone/ohjelmat/mksh/share/man/man1; "
   " cp -fv mksh.1 ~/huone/ohjelmat/mksh/share/man/man1/mksh.1"))

(muki:eshell-define-build-alias
 :alias "build-stumpwm"
 :repo (muki:build-path-hoarder "github.com/stumpwm/stumpwm")
 :commands
 '("git pull;"
   "gmake clean distclean ;"
   "export SBCL_HOME=/home/mytoh/huone/ohjelmat/sbcl/lib/sbcl;"
   "./autogen.sh ;"
   "  ./configure --with-sbcl=/home/mytoh/huone/ohjelmat/sbcl/bin/sbcl --prefix=/home/mytoh/huone/ohjelmat/stumpwm &&"
   "gmake && gmake install"))

(muki:eshell-define-build-alias
 :alias "build-npm"
 :repo (muki:build-path-hoarder "github.com/npm/npm")
 :commands
 '("git pull;"
   "gmake clean;"
   "bash ./configure --prefix=/home/mytoh/huone/ohjelmat/npm --npm_config_prefix=/home/mytoh/huone/ohjelmat/npm;"
   "gmake adevelll install clean"
   ))

(muki:eshell-define-build-alias
 :alias "build-plowshare"
 :repo (muki:build-path-hoarder "github.com/mcrapet/plowshare")
 :commands
 '("gmake install GNU_SED=/usr/local/bin/gsed PREFIX=/home/mytoh/huone/ohjelmat/plowshare"))


(muki:eshell-define-build-alias
 :alias "build-roswell"
 :repo (muki:build-path-hoarder "github.com/snmsts/roswell")
 :commands
 '("gmake clean distclean;"
   " git pull;"
   " ./bootstrap; "
   "CFLAGS='-I/usr/local/include' LDFLAGS=-L/usr/local/lib ./configure --prefix=/home/mytoh/huone/ohjelmat/roswell;"
   " gmake;"
   " gmake install"))

(muki:eshell-define-build-alias
 :alias "build-chibi-scheme"
 :repo (muki:build-path-hoarder "github.com/ashinn/chibi-scheme")
 :commands
 '("gmake dist-clean;"
   " git pull;"
   "gmake PREFIX=/home/mytoh/huone/ohjelmat/chibi-scheme;"
   " gmake PREFIX=/home/mytoh/huone/ohjelmat/chibi-scheme install"))

(muki:eshell-define-build-alias
 :alias "build-neovim"
 :repo (muki:build-path-hoarder  "github.com/neovim/neovim")
 :commands
 '("rm -rf build;"
   "git pull;"
   "gmake CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_EXTRA_FLAGS=\"-DCMAKE_INSTALL_PREFIX:PATH=/home/mytoh/huone/ohjelmat/neovim -DCMAKE_C_COMPILER=clang-devel -DCMAKE_CXX_COMPILER=clang++-devel\"  clean all install"))


(muki:eshell-define-build-alias
 :alias "build-gauche"
 :repo (muki:build-path-hoarder "github.com/shirok/Gauche")
 :commands
 '("git pull ;"
   "gmake clean distclean; "
   "./DIST gen &&"
   "./configure --prefix=/home/mytoh/huone/ohjelmat/gauche --enable-tls=axtls --with-local=/usr/local --enable-ipv6 CC=clang-devel CPP=clang-cpp-devel CXX=clang++-devel CFLAGS=\"-O2 -pipe -fstack-protector -fno-strict-aliasing\" &&"
   " gmake all install"))

(muki:eshell-define-build-alias
 :alias "build-gauche-new"
 :repo (muki:build-path-hoarder "github.com/shirok/Gauche")
 :commands
 '("git pull ;"
   "gmake clean distclean; "
   "./DIST gen &&"
   "./configure --prefix=/home/mytoh/huone/ohjelmat/gauche-new --enable-tls=axtls --with-local=/usr/local --enable-ipv6 CC=clang-devel CPP=clang-cpp-devel CXX=clang++-devel CFLAGS=\"-O2 -pipe -fstack-protector -fno-strict-aliasing\" &&"
   " gmake all install"))

(muki:eshell-define-build-alias
 :alias "build-luarocks"
 :repo (muki:build-path-hoarder "github.com/keplerproject/luarocks")
 :commands
 '("make clean;"
   "git pull;"
   "./configure --with-lua-include=/usr/local/include/lua52 --with-downloader=curl --prefix=/home/mytoh/huone/ohjelmat/luarocks &&"
   " make build &&"
   " make install"))

(muki:eshell-define-build-alias
 :alias "build-libav"
 :repo (muki:build-path-hoarder "github.com/libav/libav")
 :commands
 '("gmake clean;"
   "git pull;"
   "./configure --prefix=/home/mytoh/huone/ohjelmat/libav --extra-ldflags=\"-L/usr/local/lib\" --enable-gnutls --enable-pthreads --enable-runtime-cpudetect --disable-debug --disable-libmfx --enable-gpl --enable-nonfree --enable-libvpx --enable-libopus --enable-libwebp --enable-libx264 --enable-libx265 &&"
   " gmake &&"
   " gmake install"))

(muki:eshell-define-build-alias
 :alias "build-fish"
 :repo (muki:build-path-hoarder "github.com/fish-shell/fish-shell")
 :commands
 '( "git pull ; "
   "gmake clean distclean ; "
   "autoconf ; "
   "./configure --prefix=/home/mytoh/huone/ohjelmat/fish LDFLAGS=-L/usr/local/lib CPPFLAGS=-I/usr/local/include CXXFLAGS=-I/usr/local/include CXX=clang++-devel CXXCPP=clang-cpp-devel --with-doxygen ; "
   "gmake ; "
   "gmake install")
 :notify t)

(muki:eshell-define-build-alias
 :alias "build-highway" ; building highway!
 :repo (muki:build-path-hoarder "github.com/tkengo/highway")
 :commands
 `("gmake clean;"
   "mkdir -pv config"
   "aclocal;"
   "autoconf;"
   "autoheader;"
   "automake --add-missing;"
   ,(concat  "./configure --prefix=" (expand-file-name "ohjelmat/highway" (getenv "HUONE"))
             " LDFLAGS=-L/usr/local/lib CPPFLAGS=-I/usr/local/include"
             ";")
   "gmake;"
   "gmake install"))

(muki:eshell-define-build-alias
 :alias "build-git"
 :repo (muki:build-path-hoarder "github.com/git/git")
 :commands
 `("gmake clean;"
   "gmake configure;"
   ,(concat
     " ./configure CC=clang-devel LDFLAGS=-L/usr/local/lib CPPFLAGS=-I/usr/local/include --with-perl=/usr/local/bin/perl"
     " --enable-pthreads=-pthread ac_cv_header_libcharset_h=no "
     " --prefix=" (expand-file-name "ohjelmat/git" (getenv "HUONE"))
     ";")
   "gmake  all install"))

(muki:eshell-define-build-alias
 :alias "build-you-get"
 :repo (muki:build-path-hoarder "github.com/soimort/you-get")
 :commands
 '("git pull;"
   "python3 ./setup.py install --user"))

(muki:eshell-define-build-alias
 :alias "build-mosh"
 :repo (muki:build-path-hoarder "github.com/mobile-shell/mosh")
 :commands
 `("make clean;"
   "./autogen.sh &&"
   ,(concat
     " ./configure CC=clang-devel --with-utempter --without-ncurses "
     " --prefix=" (expand-file-name "ohjelmat/mosh" (getenv "HUONE"))
     ";")
   "make install")
 :bin
 '("mosh" "mosh-client" "mosh-server"))

(muki:eshell-define-build-alias
 :alias "build-ffmpeg"
 :repo (muki:build-path-hoarder "github.com/FFmpeg/FFmpeg")
 :commands
 `("gmake clean;"
   "git pull;"
   ;; ./configure  --prefix=/home/mytoh/huone/ohjelmat/powertop --cc=clang-devel --extra-cflags="-I/home/mytoh/huone/työkaluvaja/include -I/usr/local/include" --extra-ldflags="-L/home/mytoh/huone/työkaluvaja/lib -L/usr/local/lib"
   ,(concat
     "PKG_CONFIG_PATH=" (expand-file-name "työkaluvaja/lib/pkgconfig" (getenv "HUONE"))
     " ./configure"
     " --cc=clang-devel "
     " --cxx=clang++-devel "
     " --prefix=" (expand-file-name "ohjelmat/ffmpeg" (getenv "HUONE"))
     " --extra-cflags=\"-I/home/mytoh/huone/työkaluvaja/include -I/usr/local/include\" --extra-ldflags=\"-L/home/mytoh/huone/työkaluvaja/lib -L/usr/local/lib\" "
     " --pkg-config-flags=-static --enable-shared --enable-gnutls --enable-pthreads --disable-vdpau --enable-runtime-cpudetect --disable-debug --disable-libmfx --enable-gpl --enable-nonfree --enable-libvpx --enable-libopus --enable-libwebp --enable-libx264 && ")
   " gmake &&"
   " gmake install"))

(muki:eshell-define-build-alias
 :alias "build-imagemagick"
 :repo (muki:build-path-hoarder "github.com/ImageMagick/ImageMagick")
 :commands
 `("gmake clean;"
   "git pull;"
   ,(concat
     "./configure "
     " --prefix=" (expand-file-name "ohjelmat/imagemagick" (getenv "HUONE"))
     " --without-openjp2 --with-rsvg CC=clang CXX=clang++-devel;")
   "gmake && "
   "gmake install;"
   "gmake clean"))

(muki:eshell-define-build-alias
 :alias "build-xsel"
 :repo (muki:build-path-hoarder "github.com/kfish/xsel")
 :commands
 `("gmake clean;"
   "git pull;"
   "autoreconf -i;"
   ,(concat
     "./configure "
     " --prefix=" (expand-file-name "ohjelmat/xsel" (getenv "HUONE"))
     " CPPFLAGS=-I/usr/local/include LDFLAGS=-L/usr/local/lib;")
   "gmake && "
   "gmake install;"
   "gmake clean"))

(muki:eshell-define-build-alias
 :alias "build-mpsyt"
 :repo (muki:build-path-hoarder "github.com/mps-youtube/mps-youtube")
 :commands
 '("git pull;"
   "python3 ./setup.py clean install --user"))

(muki:eshell-define-build-alias
 :alias "build-pafy"
 :repo (muki:build-path-hoarder "github.com/mps-youtube/pafy")
 :commands
 '("git pull;"
   "python3 ./setup.py clean install --user"))

(muki:eshell-define-build-alias
 :alias "build-libsixel"
 :repo (muki:build-path-hoarder "github.com/saitoha/libsixel")
 :commands
 '("git pull;"
   "gmake clean ;"
   "./configure  --prefix=/home/mytoh/huone/ohjelmat/libsixel --with-libcurl --with-gdk-pixbuf2 ;"
   "gmake;"
   "gmake install"))

(muki:eshell-define-build-alias
 :alias "build-openssh"
 :repo (muki:build-path-hoarder "github.com/openssh/openssh-portable")
 :commands
 '("gmake clean distclean ;"
   "git pull &&"
   "autoreconf -i &&"
   "./configure  --prefix=/home/mytoh/huone/ohjelmat/openssh CC=clang-devel &&"
   "gmake &&"
   "gmake install"))

(muki:eshell-define-build-alias
 :alias "build-ricey"
 :repo (muki:build-path-hoarder "github.com/RubenRocha/ricey")
 :commands
 '("git pull &&"
   "rm -v ricey ;"
   "clang++-devel -I/usr/local/include -L/usr/local/lib -lX11 -lmemstat main.cpp functions.cpp bsd.cpp -w -o ricey"))

(muki:eshell-define-build-alias
 :alias "build-htop"
 :repo (muki:build-path-hoarder "github.com/hishamhm/htop")
 :commands
 `("git pull &&"
   "gmake clean &&"
   ;; "./configure --enable-proc --with-proc=/compat/linux/proc --enable-unicode "
   "./configure --enable-unicode "
   ,(concat " --prefix=" (expand-file-name "ohjelmat/htop" (getenv "HUONE")) " &&")
   "gmake &&"
   "gmake install"))

(muki:eshell-define-build-alias
 :alias "build-lrzip"
 :repo (muki:build-path-hoarder "github.com/ckolivas/lrzip")
 :commands
 `("gmake clean &&"
   "./autogen.sh &&"
   "./configure --prefix=/home/mytoh/huone/ohjelmat/lrzip LDFLAGS=-L/usr/local/lib CFLAGS=-I/usr/local/include &&"
   "gmake &&"
   "gmake install"))

(muki:eshell-define-build-alias
 :alias "build-n30f"
 :repo (muki:build-path-hoarder "github.com/sdhand/n30f")
 :commands
 `("gmake clean &&"
   "gcc -L/usr/local/lib -I/usr/local/include n30f.c -o n30f -lcairo -lxcb -lxcb-render &&"
   " PREFIX=/home/mytoh/huone/ohjelmat/n30f gmake install"))

(muki:eshell-define-build-alias
 :alias "build-xz"
 :repo (muki:build-path-hoarder "git.tukaani.org/xz.git")
 :commands
 `("gmake clean ;"
   "./autogen.sh &&"
   ,(concat "./configure --prefix="
            (expand-file-name
             "ohjelmat/xz"
             (getenv "HUONE"))
            " &&")
   "gmake &&"
   "gmake install"))

(muki:eshell-define-build-alias
 :alias "build-ag"
 :repo (muki:build-path-hoarder "github.com/ggreer/the_silver_searcher")
 :commands
 `("gmake clean ;"
   "aclocal -I/usr/local/share/aclocal &&"
   "autoconf &&"
   "autoheader &&"
   "automake --add-missing &&"
   ,(concat "./configure LZMA_LIBS=-llzma LZMA_CFLAGS=-I/usr/include "
            "--prefix=" (expand-file-name "ohjelmat/ag" (getenv "HUONE"))
            " &&")
   "gmake &&"
   "gmake install"))

(muki:eshell-define-build-alias
 :alias "build-libressl"
 :repo (muki:build-path-hoarder "github.com/libressl-portable/portable")
 :commands
 `("git pull &&"
   "gmake clean;"
   "./autogen.sh &&"
   ,(concat "./configure --enable-nc "
            "--prefix=" (expand-file-name "ohjelmat/libressl" (getenv "HUONE"))
            " &&")
   "gmake &&"
   "gmake install"))

(muki:eshell-define-build-alias
 :alias "build-pqiv"
 :repo (muki:build-path-hoarder "github.com/phillipberndt/pqiv")
 :commands
 `("gmake clean ;"
   "git pull &&"
   "./configure --prefix=/home/mytoh/huone/ohjelmat/pqiv --with-libav &&"
   "gmake &&"
   ,(concat "mkdir -pv "
            (expand-file-name
             "pqiv/bin"
             (getenv "HUONE_OHJELMAT"))
            " ;")
   ,(concat "ginstall -v pqiv "
            (expand-file-name "pqiv/bin/pqiv"
                              (getenv "HUONE_OHJELMAT"))
            " &&")
   ,(concat "mkdir -pv "
            (expand-file-name "pqiv/share/man/man1"
                              (getenv "HUONE_OHJELMAT"))
            " ;")

   ,(concat "ginstall -v --mode=644 pqiv.1 "
            (expand-file-name "pqiv/share/man/man1/pqiv.1"
                              (getenv "HUONE_OHJELMAT"))
            )))

(muki:eshell-define-build-alias
 :alias "build-taglib"
 :repo (muki:build-path-hoarder "github.com/taglib/taglib")
 :commands
 `(,(concat "cmake -DCMAKE_BUILD_TYPE=Release  -DCMAKE_C_COMPILER=/usr/local/bin/clang-devel  -DCMAKE_CXX_COMPILER=/usr/local/bin/clang++-devel "
            " -DCMAKE_INSTALL_PREFIX="
            (expand-file-name "taglib"
                              (getenv "HUONE_OHJELMAT"))
            " . &&")
    "gmake && "
    "gmake install"))

(muki:eshell-define-build-alias
 :alias "build-fluxbox"
 :repo (muki:build-path-hoarder "git.fluxbox.org/fluxbox.git")
 :commands
 `("gmake clean ;"
   "git pull &&"
   ,(concat "./configure --enable-nc "
            "--prefix=" (expand-file-name "ohjelmat/fluxbox" (getenv "HUONE"))
            " &&")
   "gmake &&"
   "gmake install"))

(muki:eshell-define-build-alias
 :alias "build-libxo"
 :repo (muki:build-path-hoarder "github.com/Juniper/libxo")
 :commands
 `("git pull &&"
   "rm -rf build ;"
   "sh bin/setup.sh ;"
   "cd build ;"
   ,(concat "../configure "
            "--prefix=" (expand-file-name "ohjelmat/libxo" (getenv "HUONE"))
            " &&")
   "gmake &&"
   "gmake install"))

(muki:eshell-define-build-alias
 :alias "build-tor"
 :repo (muki:build-path-hoarder "git.torproject.org/tor.git")
 :commands
 `("git pull"
   "; gmake distclean"
   ,(concat ";" "./configure --prefix=" (expand-file-name "tor" (getenv "HUONE_OHJELMAT"))
            " --with-openssl-dir=/usr/local CC=clang-devel --disable-asciidoc")
   "; gmake"
   "; gmake install"))

(muki:eshell-define-build-alias
 :alias "build-openbox"
 :repo (muki:build-path-hoarder "git.openbox.org/mikachu/openbox")
 :commands
 `("git pull;"
   "gmake clean;"
   "./bootstrap;"
   ,(concat "./configure --prefix=" (expand-file-name "openbox" (getenv "HUONE_OHJELMAT")))
   "; gmake"
   "; gmake install"))


(muki:eshell-define-build-alias
 :alias "build-obconf"
 :repo (muki:build-path-hoarder "git.openbox.org/dana/openbox")
 :commands
 `("git pull;"
   "gmake clean;"
   "./bootstrap;"
   ,(concat "./configure --prefix=" (expand-file-name "obconf" (getenv "HUONE_OHJELMAT")))
   "; gmake"
   "; gmake install"))

(muki:eshell-define-build-alias
 :alias "build-openbox-menu"
 :repo (muki:build-path-hoarder "bitbucket.org/fabriceT/openbox-menu")
 :commands
 `("hg pull -u;"
   "gmake clean;"
   "gmake;"
   ,(concat "mkdir -p "
            (expand-file-name "openbox-menu/bin" (getenv "HUONE_OHJELMAT"))
            ";")
   
   ,(concat "cp -v openbox-menu "
            (expand-file-name "openbox-menu/bin" (getenv "HUONE_OHJELMAT")))))

(muki:eshell-define-build-alias
 :alias "build-fvwm"
 :repo (muki:build-path-hoarder "github.com/fvwmorg/fvwm")
 :commands
 `("git pull;"
   "autoreconf -f -i -v;"
   ,(concat "./configure --prefix=" (expand-file-name "fvwm" (getenv "HUONE_OHJELMAT"))
            ";")
   "gmake;"
   "gmake install"))

(muki:eshell-define-build-alias
 :alias "build-cwm"
 :repo (muki:build-path-hoarder "github.com/chneukirchen/cwm")
 :commands
 `("git pull;"
   "make clean;"
   "make "
   ,(concat "PREFIX="
            (expand-file-name "cwm" (getenv "HUONE_OHJELMAT")))
   " install"))

(muki:eshell-define-build-alias
 :alias "build-ratpoison"
 :repo (muki:build-path-hoarder "git.savannah.nongnu.org/ratpoison.git")
 :commands
 `("git pull;"
   "./autogen.sh;"
   ,(concat "./configure -with-x --prefix="
            (expand-file-name "ratpoison" (getenv "HUONE_OHJELMAT"))
            ";")
   "gmake;"
   "gmake install;" 
   "gmake clean"))

(muki:eshell-define-build-alias
 :alias "build-vdesk"
 :repo (muki:build-path-hoarder "offog.org/git/vdesk.git")
 :commands
 `("git pull;"
   "./autogen.sh;"
   ,(concat "./configure --prefix="
            (expand-file-name "vdesk" (getenv "HUONE_OHJELMAT"))
            ";")
   "gmake;"
   "gmake install;" 
   "gmake clean"))

(muki:eshell-define-build-alias
 :alias "build-vtwm"
 :repo (muki:build-path-hoarder "git.code.sf.net/p/vtwm/code")
 :commands
 `("git pull;"
   ,(concat "./configure --prefix="
            (expand-file-name "vtwm" (getenv "HUONE_OHJELMAT"))
            ";")
   "gmake;"
   "gmake install;" 
   "gmake clean"))

(muki:eshell-define-build-alias
 :alias "build-2bwm"
 :repo (muki:build-path-hoarder "github.com/venam/2bwm")
 :commands
 `("git pull;"
   "gmake clean;"
   ,(concat "gmake PREFIX="
            (expand-file-name "2bwm" (getenv "HUONE_OHJELMAT"))
            " install;")))

(muki:eshell-define-build-alias
 :alias "build-clipit"
 :repo (muki:build-path-hoarder "github.com/CristianHenzel/ClipIt")
 :commands
 `("git pull;"
   "./autogen.sh;"
   ,(concat "./configure --prefix="
            (expand-file-name "clipit" (getenv "HUONE_OHJELMAT"))
            ";")
   "gmake;"
   "gmake install;" 
   "gmake clean"))

(muki:eshell-define-build-alias
 :alias "build-curl"
 :repo (muki:build-path-hoarder "github.com/curl/curl")
 :commands
 `("git pull;"
   "gmake clean;"
   "./buildconf;"
   ,(concat "./configure --prefix="
            (expand-file-name "curl" (getenv "HUONE_OHJELMAT"))
            " --enable-ares "
            " --with-ca-bundle=/usr/local/share/certs/ca-root-nss.crt "
            ";")
   "gmake;"
   "gmake install;"
   "gmake clean"))

(muki:eshell-define-build-alias
 :alias "build-httpie"
 :repo (muki:build-path-hoarder "github.com/jkbrzt/httpie")
 :commands
 '("git pull;"
   "python3 ./setup.py clean install --user"))

(muki:eshell-define-build-alias
 :alias "build-maxwelm"
 :repo (muki:build-path-hoarder "github.com/zsisco/maxwelm")
 :commands
 `("git pull;"
   "gmake CFLAGS='-I/usr/local/include'  CC=clang-devel LDFLAGS=-L/usr/local/lib;"
   ,(concat  "ginstall -Dm 755 maxwelm "
             (expand-file-name "maxwelm" (getenv "HUONE_OHJELMAT"))
             "/bin/maxwelm"
             ";")
   "gmake clean"))

(muki:eshell-define-build-alias
 :alias "build-libao"
 :repo (muki:build-path-hoarder "git.xiph.org/libao.git")
 :commands
 `("git pull;"
   "gmake clean;"
   "./autogen.sh;"
   ,(concat "./configure --prefix="
            (expand-file-name "libao" (getenv "HUONE_OHJELMAT"))
            ";")
   "gmake;"
   "gmake install;"
   "gmake clean"))

(muki:eshell-define-build-alias
 :alias "build-sox"
 :repo (muki:build-path-hoarder "git.code.sf.net/p/sox/code")
 :commands
 `("git pull;"
   "autoreconf -i;"
   ,(concat "./configure --prefix="
            (expand-file-name "sox" (getenv "HUONE_OHJELMAT"))
            ";")
   "gmake -s;"
   "gmake install;"
   "gmake clean"))

(muki:eshell-define-build-alias
 :alias "build-mpv"
 :repo (muki:build-path-hoarder "github.com/mpv-player/mpv")
 :commands
 `("git pull;"
   "./bootstrap.py"
   "./waf clean;"
   ,(concat "CC=gcc6 "
            " CPPFLAGS='-I/usr/local/include "
            "-I"
            (expand-file-name "työkaluvaja/include" (getenv "HUONE"))
            "'"
            " LDFLAGS='-L/usr/local/lib "
            "-L"
            (expand-file-name "työkaluvaja/lib" (getenv "HUONE"))
            "'"
            " ./waf configure --disable-debug-build \
 --disable-optimize  --disable-pdf  \
--disable-rubberband \
  --disable-vaapi-wayland  \
--disable-vapoursynth  \
--disable-vapoursynth-lazy  \
--disable-videotoolbox-hwaccel  \
--disable-videotoolbox-gl  \
--disable-wayland  \
--enable-libmpv-shared     \
--disable-pulse \
--enable-oss-audio \
--disable-egl-x11 \
--disable-egl-drm "
            " --prefix="
            (expand-file-name "mpv" (getenv "HUONE_OHJELMAT"))
            " ;")
   " ./waf &&"
   " ./waf install;"
   "./waf clean"))

(muki:eshell-define-build-alias
 :alias "build-libvpx"
 :repo (muki:build-path-hoarder "chromium.googlesource.com/webm/libvpx")
 :commands
 `("gmake clean;"
   ,(concat 
     "CC=gcc6 CXX=g++6 ./configure  --disable-unit-tests --enable-shared"
     " --prefix="
     (expand-file-name "libvpx" (getenv "HUONE_OHJELMAT"))
     " &&")
   "gmake &&"
   "gmake install ;"
   "gmake clean"))

(muki:eshell-define-build-alias
 :alias "build-yasm"
 :repo (muki:build-path-hoarder "github.com/yasm/yasm")
 :commands
 `("git pull;"
   ,(concat "./autogen.sh --prefix="
            (expand-file-name "yasm" (getenv "HUONE_OHJELMAT"))
            ";")
   "gmake;"
   "gmake install;"
   "gmake clean"))

(muki:eshell-define-build-alias
 :alias "build-x265"
 :repo (muki:build-path-hoarder "github.com/videolan/x265")
 :commands
 `("git pull;"
   "cd build;"
   "gmake clean;"
   ,(concat "cmake -DCMAKE_INSTALL_PREFIX="
            (expand-file-name "x265" (getenv "HUONE_OHJELMAT"))
            " ../source ;")
   "gmake &&"
   "gmake install ;"
   "gmake clean"))

(muki:eshell-define-build-alias
 :alias "build-xst"
 :repo (muki:build-path-hoarder "github.com/neeasade/xst")
 :commands
 `("git pull;"
   "gmake clean;"
   ,(concat "gmake PREFIX="
            (expand-file-name "xst" (getenv "HUONE_OHJELMAT"))
            ";")
   ,(concat "gmake PREFIX="
            (expand-file-name "xst" (getenv "HUONE_OHJELMAT"))
            " install ;")
   "gmake clean"))

;; cd ~/huone/git/github.com/knopwob/dunst/ ; gmake clean ; gmake PREFIX=/home/mytoh/huone/ohjelmat/dunst install

;;; build.el ends here
