#!/bin/bash

set -e
set -u

declare ARCH="unix"
declare FTP_VIM_PATH="pub/vim"
declare SRC_ARC_URL_PATH="ftp://ftp.vim.org/$FTP_VIM_PATH/$ARCH"
declare CUR_DIR=/usr/local/vim
#declare INSTALL_DIR="$HOME/local/bin"
mkdir -p $CUR_DIR

    
ARCH="unix"
FILE_VERSIONS_LIST="$CUR_DIR/.vim-versions"
ARC_DIR="$CUR_DIR/vim"

if type wget >/dev/null 2>&1; then
    DOWNLOADER='wget'
elif type curl >/dev/null 2>&1; then
    DOWNLOADER='curl -O'
fi

# usage {{{1
usage() {
    echo "Usage: $0 [install|build|clean|update|versions] [TARGET_VERSION]"
}

get_version() {
    cd $CUR_DIR
    ftp -n -i  <<-EOF
open ftp.vim.org
user anonymous pass
cd $FTP_VIM_PATH/$ARCH
pwd
nlist vim-* $FILE_VERSIONS_LIST
bye
EOF
}

# disp_version {{{1
disp_version() {
    cd $CUR_DIR
    if [ ! -f $FILE_VERSIONS_LIST ];then
        get_version
    fi
    grep -v ".diff." $FILE_VERSIONS_LIST | cut -d"." -f1-2 | cut -d"-" -f2-
}

# disp_version_latest {{{1
disp_version_latest() {
    cd $CUR_DIR
    disp_version | tail -1
}
#}}}

declare TARGET_VERSION=""
#if [ "$1" = "install" -o "$1" = "build" -o "$1" = "clean" -o "$1" = "update" ]; then
#    COMMAND=$1
#    if [ "$2" = "" ];then
#        TARGET_VERSION=`disp_version_latest`
#    else
#        TARGET_VERSION=$2
#    fi
#elif [ "$1" = "versions" ];then
#    COMMAND=$1
#    TARGET_VERSION=""
#else
#    COMMAND="install"
#    if [ "$1" = "" ];then
#        TARGET_VERSION=`disp_version_latest`
#    else
#        TARGET_VERSION=$1
#    fi
#fi

if [[ "${1:-none}" == "versions" ]]; then
    disp_version
    exit
fi

declare TARGET_VERSION=$(disp_version | sort | uniq | grep -x "${1:-$(disp_version_latest)}" || disp_version_latest)
#declare TARGET_TARBALL=$(grep -E "^vim-$TARGET_VERSION\." "$FILE_VERSIONS_LIST")
#if [ "$TARGET_VERSION" != "" ];then
    SRC_DIR="$CUR_DIR/build/$TARGET_VERSION"
    BIN_DIR="$CUR_DIR/bin/$TARGET_VERSION"
    PATCH_DIR="$CUR_DIR/patches/$TARGET_VERSION"
#else
#    SRC_DIR=""
#    BIN_DIR=""
#    PATCH_DIR=""
#fi

# command_clean {{{1
command_clean() {
    cd $CUR_DIR
    rm -fr \
    $SRC_DIR \
    $BIN_DIR \
    $PATCH_DIR \
    $FILE_VERSIONS_LIST
}
#}}}

#if [ "$COMMAND" = "clean" ];then
#    if [ "$SRC_DIR" = "" -o "$PATCH_DIR" = "" ]; then
#        echo "error: SRC_DIR or PATCH_DIR none."
#        exit
#    fi
#    command_clean
#    exit
#elif [ "$COMMAND" = "versions" ];then
#    disp_version
#    exit
#fi

SRC_ARC_FILENAME=""
if [ "$TARGET_VERSION" != "" ];then
    if [ ! -f $FILE_VERSIONS_LIST ];then
        echo "not found $FILE_VERSIONS_LIST"
        exit
    fi
    SRC_ARC_FILENAME=`egrep "^vim-"$TARGET_VERSION"\." $FILE_VERSIONS_LIST`
fi

# download_vim_source {{{1
download_vim_source() {
    cd $CUR_DIR
    mkdir -p $ARC_DIR
    cd $ARC_DIR
    if [ ! -f "$SRC_ARC_FILENAME" ]; then
        curl -O $SRC_ARC_URL_PATH/$SRC_ARC_FILENAME
    fi
}

FILE_PATCHES_LIST="$PATCH_DIR/.vim-patches"

# get_patch_list {{{1
get_patch_list() {
    cd $CUR_DIR
    mkdir -p $PATCH_DIR
    cd $PATCH_DIR
    ftp -n -i  <<EOF
open ftp.vim.org
user anonymous pass
cd $FTP_VIM_PATH/patches/$TARGET_VERSION
pwd
nlist $TARGET_VERSION.* $FILE_PATCHES_LIST
bye
EOF
}

# download_patch {{{1
download_patch() {
    cd $CUR_DIR
    cd $PATCH_DIR
    rm -f $FILE_PATCHES_LIST.u
    cat $FILE_PATCHES_LIST | while read PATCH_FILE; do
        URL_PATCH_FILE="http://ftp.vim.org/$FTP_VIM_PATH/patches/$TARGET_VERSION/$PATCH_FILE"
        echo "$URL_PATCH_FILE" >> $FILE_PATCHES_LIST.u
    done
    cat $FILE_PATCHES_LIST.u | xargs wget -N -c
}

# uncompress_vim_source {{{1
uncompress_vim_source() {
    cd $CUR_DIR
    rm -fr $SRC_DIR
    mkdir -p $SRC_DIR
    mkdir -p $BIN_DIR
    cd $SRC_DIR
    tar -xvjf $ARC_DIR/$SRC_ARC_FILENAME
}

# run_patch {{{1
run_patch() {
    cd $PATCH_DIR
    patchlist=`ls -v $TARGET_VERSION.*`
    cd $SRC_DIR
    SRC_CORE_DIR=`ls | grep vim`
    cd $SRC_CORE_DIR
    for patchfile in $patchlist; do
        cat $PATCH_DIR/$patchfile
    done | patch -p0
}

# run_configure {{{1
run_configure() {
    cd $SRC_DIR/$SRC_CORE_DIR
    ./configure \
        --with-features=huge \
        --with-compiledby="b4b4r07 <b4b4r07@gmail.com>" \
        --enable-multibyte \
        --enable-fontset \
        --enable-cscope \
        --enable-luainterp \
        --disable-selinux \
        --prefix="$BIN_DIR"
}

# build_vim {{{1
build_vim() {
    cd $SRC_DIR/$SRC_CORE_DIR
    make clean
    make
    make install
}
#}}}

if [ "$SRC_DIR" = "" -o "$PATCH_DIR" = "" ]; then
    echo "error: SRC_DIR or PATCH_DIR none."
    exit
fi

#if [ "$COMMAND" = "update" ];then
#    command_clean
#    get_version
#    download_vim_source
#    get_patch_list
#    download_patch
#    exit
#elif [ "$COMMAND" = "install" ];then
##    get_version
##    command_clean
#    download_vim_source
#    get_patch_list
#    download_patch
#    uncompress_vim_source
#    run_patch
#    run_configure
#    build_vim
#elif [ "$COMMAND" = "build" ];then
#    uncompress_vim_source
#    run_patch
#    run_configure
#    build_vim
#fi
    download_vim_source
    get_patch_list
    download_patch
    uncompress_vim_source
    run_patch
    run_configure
    build_vim

echo "To use this vim, do 'export PATH=$SRC_DIR/$SRC_CORE_DIR/src:\$PATH'."

#declare TARGET_VERSION=$(disp_version | sort | uniq | grep -x "${1:-$(disp_version_latest)}" || disp_version_latest)
#declare TARGET_TARBALL=$(grep -E "^vim-$TARGET_VERSION\." "$FILE_VERSIONS_LIST")
# vim:fdm=marker expandtab fdc=3 ts=4 sw=4 sts=4:
