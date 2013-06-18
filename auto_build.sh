#!/bin/bash

setup_env () {
	export LFS=/home/tsuro/workspace/msc/opt
	export LC_ALL=POSIX
	export LFS_TGT=x86_64-lfs-linux-gnu
	export PATH=/tools/bin:/bin:/usr/bin
	export MAKEFLAGS='-j 2'
}

setup_dirs () {
	if [ -f $LFS/tools ]; then
		rm -Rf $LFS/tools
	fi
	mkdir -p $LFS/tools
	if [ ! -f /tools ]; then
		sudo ln -sv $LFS/tools /
	fi
}

build_binutils () {

	if [ ! -f binutils-2.23.2 ]; then
		wget http://ftp.gnu.org/gnu/binutils/binutils-2.23.2.tar.gz || exit 1
		tar -xf binutils-2.23.2.tar.gz || exit 1
		rm binutils-2.23.2.tar.gz
	fi

	if [ -f binutils-build ]; then
		rm -Rf binutils-build
	fi

	mkdir binutils-build
	cd binutils-build

	#../binutils-2.23.2/configure --with-lib-path=/tools/lib --disable-werror
	../binutils-2.23.2/configure --prefix=/tools --with-sysroot=$LFS --with-lib-path=/tools/lib --disable-nls --disable-werror || exit 1
	make || exit 1
	case $(uname -m) in
		x86_64) mkdir -v /tools/lib && ln -sv lib /tools/lib64 ;;
	esac
	make install
}

setup_env
setup_dirs
build_binutils
