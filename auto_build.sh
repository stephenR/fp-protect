#!/bin/bash

set -v

setup_env () {
	echo "[*] Setting up environment"
	export LFS=/home/tsuro/workspace/msc/opt
	export LC_ALL=POSIX
	export LFS_TGT=x86_64-lfs-linux-gnu
	export PATH=/tools/bin:/bin:/usr/bin
	if [ ! $DEBUG ]; then
		export MAKEFLAGS='-j 2'
	fi
}

setup_dirs () {
	echo "[*] Setting up system directories"
	if [ -d $LFS/tools ]; then
		rm -Rf $LFS/tools
	fi
	mkdir -p $LFS/tools
	if [ ! -d /tools ]; then
		sudo ln -sv $LFS/tools /
	fi
}

build_binutils () {
	echo "[*] binutils build process started"

	if [ ! -d binutils-2.23.2 ]; then
		echo "[*] Downloading binutils"
		wget http://ftp.gnu.org/gnu/binutils/binutils-2.23.2.tar.gz || exit 1
		tar -xf binutils-2.23.2.tar.gz || exit 1
		rm binutils-2.23.2.tar.gz
	fi

	if [ -d binutils-build ]; then
		echo "[*] removing binutils build directory"
		rm -Rf binutils-build
	fi

	mkdir binutils-build
	cd binutils-build

	echo "[*] Configuring"
	#../binutils-2.23.2/configure --with-lib-path=/tools/lib --disable-werror
	../binutils-2.23.2/configure --prefix=/tools --with-sysroot=$LFS --with-lib-path=/tools/lib --disable-nls --disable-werror || exit 1
	echo "[*] Compiling"
	make $MAKEFLAGS || exit 1
	case $(uname -m) in
		x86_64) mkdir -v /tools/lib && ln -sv lib /tools/lib64 ;;
	esac
	echo "[*] Installing"
	make $MAKEFLAGS install || exit 1
	echo "[*] binutils build process finished"
	cd ..

	if [ ! $DEBUG ]; then
		echo "[*] removing binutils build directory"
		rm -Rf binutils-build
	fi
}

build_gcc_pass1 () {
	echo "[*] gcc pass 1 build process started"

	echo "[*] Checking out / updating fpp gcc"
	if [ ! -d gcc ]; then
		git clone git@zero-entropy.de:gcc.git gcc || exit 1
		cd gcc
		git checkout -b fpprotect origin/fpprotect_gimple
		cd ..
	fi
	cd gcc

	for file in $(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h)
	do
		git checkout $file
	done
	git checkout gcc/configure
	git pull

	for file in $(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h)
	do
		cp -uv $file{,.orig}
		sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g' \
			-e 's@/usr@/tools@g' $file.orig > $file
		echo '
#undef STANDARD_STARTFILE_PREFIX_1
#undef STANDARD_STARTFILE_PREFIX_2
#define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"
#define STANDARD_STARTFILE_PREFIX_2 ""' >> $file
		touch $file.orig
	done

	sed -i '/k prot/agcc_cv_libc_provides_ssp=yes' gcc/configure
	sed -i 's/BUILD_INFO=info/BUILD_INFO=/' gcc/configure

	echo "[*] downloading mpfr"
	wget http://www.mpfr.org/mpfr-3.1.1/mpfr-3.1.1.tar.xz || exit 1
	tar -xf mpfr-3.1.1.tar.xz || exit 1
	rm mpfr-3.1.1.tar.xz 
	if [ -d mpfr ]; then
		rm -Rf mpfr
	fi
	mv mpfr-3.1.1 mpfr

	echo "[*] downloading mpc"
	wget http://www.multiprecision.org/mpc/download/mpc-1.0.1.tar.gz || exit 1
	tar -xf mpc-1.0.1.tar.gz || exit 1
	rm mpc-1.0.1.tar.gz
	if [ -d mpc ]; then
		rm -Rf mpc
	fi
	mv mpc-1.0.1 mpc

	echo "[*] downloading gmp"
	wget ftp://ftp.gmplib.org/pub/gmp-5.1.1/gmp-5.1.1.tar.xz || exit 1
	tar -xf gmp-5.1.1.tar.xz || exit 1
	rm gmp-5.1.1.tar.xz
	if [ -d gmp ]; then
		rm -Rf gmp
	fi
	mv gmp-5.1.1 gmp

	cd ..

	if [ -d gcc-build ]; then
		echo "[*] removing gcc build directory"
		rm -Rf gcc-build
	fi

	mkdir gcc-build
	cd gcc-build

	echo "[*] Configuring"
	../gcc/configure --target=$LFS_TGT --prefix=/tools --with-sysroot=$LFS --with-newlib --without-headers --with-local-prefix=/tools --with-native-system-header-dir=/tools/include --disable-nls --disable-shared --disable-multilib --disable-decimal-float --disable-threads --disable-libmudflap --disable-libssp --disable-libgomp --disable-libquadmath --enable-languages=c --with-mpfr-include=$PWD/../gcc/mpfr/src --with-mpfr-lib=$PWD/mpfr/src/.libs --disable-libatomic || exit 1
	echo "[*] Compiling"
	make $MAKEFLAGS || exit 1

	echo "[*] Installing"
	make $MAKEFLAGS install || exit 1

	ln -sv libgcc.a `$LFS_TGT-gcc -print-libgcc-file-name | sed 's/libgcc/&_eh/'`

	cd ..

	if [ ! $DEBUG ]; then
		echo "[*] removing gcc build directories"
		rm -Rf gcc-build
		rm -Rf gcc/mpfr
		rm -Rf gcc/mpc
		rm -Rf gcc/gmp
	fi

	echo "[*] gcc pass 1 build process finished"
}

setup_env
setup_dirs
build_binutils
build_gcc_pass1

#libc configparms

#pass 2 modify configure

	#../gcc/configure CFLAGS="-gdwarf-2 -g3 -O0" CXXFLAGS="-gdwarf-2 -g3 -O0" LDFLAGS="-gdwarf-2 -g3 -O0" CFLAGS_FOR_TARGET="-gdwarf-2 -g3 -O0 -ffp-protect" --prefix=/tools --with-local-prefix=/tools --with-native-system-header-dir=/tools/include --enable-clocale=gnu --enable-shared --enable-threads=posix --enable-__cxa_atexit --enable-languages=c --disable-libstdcxx-pch --disable-multilib --disable-bootstrap --disable-libgomp --with-mpfr-include=$(pwd)../mpfr/src --with-mpfr-lib=$(pwd)/mpfr/src/.lib
