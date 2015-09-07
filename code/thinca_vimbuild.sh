#!/bin/bash
 
conf() {
	./configure \
	--with-features=huge \
	--with-compiledby="thinca <thinca@gmail.com>" \
	--enable-multibyte \
	--enable-gui=gtk2 \
	--enable-rubyinterp \
	--enable-pythoninterp \
	--enable-python3interp \
	--enable-perlinterp \
	--enable-tclinterp \
	--enable-mzschemeinterp \
	--enable-luainterp \
	--with-lua-prefix=/usr \
	--enable-gpm \
	--enable-xim \
	--enable-cscope \
	--enable-fontset \
	--prefix=$HOME/local "$*"
}
 
clean() {
	hg revert -a &&\
	/bin/rm -f $(hg st -in)
}
 
build() {
	conf &&\
	make &&\
	paco -D make install &&\
	clean
}
 
update() {
	if hg incoming >/dev/null
	then
		hg pull &&\
		hg rebase --dest default --keepbranches &&\
		build
	fi
}
 
${1:-update}
