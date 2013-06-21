#!/bin/bash

#KEEP_ARCHIVES=1
FPPROTECT_FLAGS="-ffp-protect"
FINAL_PATH="/tools"

setup_env () {
	echo "[*] Setting up environment"
	export LFS=~/workspace/fpp
	export LC_ALL=POSIX
	export LFS_TGT=x86_64-lfs-linux-gnu
	export PATH="$FINAL_PATH/bin:/bin:/usr/bin"
	if [ ! $DEBUG ]; then
		export MAKEFLAGS='-j 3'
	fi
}

setup_dirs () {
	echo "[*] Setting up system directories"
	if [ ! -d $LFS/tools ]; then
		mkdir -p $LFS/tools
	fi
	if [ ! -d $FINAL_PATH ]; then
		echo "Please create a symlink from $FINAL_PATH to $LFS/tools first"
		echo "e.g.: \"sudo ln -sv $LFS/tools $FINAL_PATH\""
		exit 1
	fi
}

build_binutils_pass_1 () {
	echo "[*] binutils pass 1 build process started"

	if [ ! -d binutils-2.23.2 ]; then
		echo "[*] Downloading binutils"
		if [ ! -f binutils-2.23.2.tar.gz ]; then
			wget http://ftp.gnu.org/gnu/binutils/binutils-2.23.2.tar.gz || exit 1
		fi
		tar -xf binutils-2.23.2.tar.gz || exit 1
		if [ ! $KEEP_ARCHIVES ]; then
			rm binutils-2.23.2.tar.gz
		fi
	fi

	if [ -d binutils-build ]; then
		echo "[*] removing binutils build directory"
		rm -Rf binutils-build
	fi

	mkdir binutils-build
	cd binutils-build

	echo "[*] Configuring"
	../binutils-2.23.2/configure --prefix=$FINAL_PATH --with-sysroot=$LFS --with-lib-path=$FINAL_PATH/lib --target=$LFS_TGT --disable-nls --disable-werror || exit 1
	echo "[*] Compiling"
	make $MAKEFLAGS || exit 1
	case $(uname -m) in
		x86_64) mkdir -v $FINAL_PATH/lib && ln -sv lib $FINAL_PATH/lib64 ;;
	esac
	echo "[*] Installing"
	make $MAKEFLAGS install || exit 1
	echo "[*] binutils pass 1 build process finished"
	cd ..

	if [ ! $DEBUG ]; then
		echo "[*] removing binutils build directory"
		rm -Rf binutils-build
	fi
}

revert_gcc () {
	for file in $(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h)
	do
		git checkout $file || exit 1
	done
	git checkout gcc/configure || exit 1
}
gcc_download_deps () {
	if [ ! -f mpfr-3.1.1.tar.xz ]; then
		echo "[*] downloading mpfr"
		wget http://www.mpfr.org/mpfr-3.1.1/mpfr-3.1.1.tar.xz || exit 1
	fi
	tar -xf mpfr-3.1.1.tar.xz || exit 1
	if [ ! $KEEP_ARCHIVES ]; then
		rm mpfr-3.1.1.tar.xz 
	fi
	if [ -d mpfr ]; then
		rm -Rf mpfr
	fi
	mv mpfr-3.1.1 mpfr

	if [ ! -f mpc-1.0.1.tar.gz ]; then
		echo "[*] downloading mpc"
		wget http://www.multiprecision.org/mpc/download/mpc-1.0.1.tar.gz || exit 1
	fi
	tar -xf mpc-1.0.1.tar.gz || exit 1
	if [ ! $KEEP_ARCHIVES ]; then
		rm mpc-1.0.1.tar.gz
	fi
	if [ -d mpc ]; then
		rm -Rf mpc
	fi
	mv mpc-1.0.1 mpc

	if [ ! -f gmp-5.1.1.tar.xz ]; then
		echo "[*] downloading gmp"
		wget ftp://ftp.gmplib.org/pub/gmp-5.1.1/gmp-5.1.1.tar.xz || exit 1
	fi
	tar -xf gmp-5.1.1.tar.xz || exit 1
	if [ ! $KEEP_ARCHIVES ]; then
		rm gmp-5.1.1.tar.xz
	fi
	if [ -d gmp ]; then
		rm -Rf gmp
	fi
	mv gmp-5.1.1 gmp
}

gcc_setup () {
	if [ $FPPROTECT_FLAGS ]; then
		GCC_FOLDER=gcc
	else
		GCC_FOLDER=gcc-nofpp
	fi

	git clone git://sourceware.org/git/glibc.git

	echo "[*] Checking out / updating fpp gcc"
	if [ ! -d $GCC_FOLDER ]; then
		if [ $FPPROTECT_FLAGS ]; then
			git clone git://zero-entropy.de/gcc.git $GCC_FOLDER || exit 1
		else
			git clone git://gcc.gnu.org/git/gcc.git $GCC_FOLDER || exit 1
		fi
		cd $GCC_FOLDER
		if [ $FPPROTECT_FLAGS ]; then
			git checkout -b fpprotect origin/fpprotect_gimple || exit 1
		else
			git checkout 31d89c5 || exit 1
		fi
		cd ..
	fi
	cd $GCC_FOLDER

	revert_gcc

	if [ $FPPROTECT_FLAGS ]; then
		git pull origin fpprotect_gimple
	fi

	for file in $(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h)
	do
		cp -uv $file{,.orig}
		sed -e "s@/lib\(64\)\?\(32\)\?/ld@${FINAL_PATH}&@g" \
			-e "s@/usr@${FINAL_PATH}@g" $file.orig > $file
		echo "
#undef STANDARD_STARTFILE_PREFIX_1
#undef STANDARD_STARTFILE_PREFIX_2
#define STANDARD_STARTFILE_PREFIX_1 \"$FINAL_PATH/lib/\"
#define STANDARD_STARTFILE_PREFIX_2 \"\"" >> $file
		touch $file.orig
	done

	sed -i 's/BUILD_INFO=info/BUILD_INFO=/' gcc/configure
}

gcc_cleanup () {
	if [ ! $DEBUG ]; then
		echo "[*] removing gcc build directories"
		rm -Rf gcc-build
		rm -Rf $GCC_FOLDER/mpfr
		rm -Rf $GCC_FOLDER/mpc
		rm -Rf $GCC_FOLDER/gmp
	fi
}

build_gcc_pass_1 () {
	echo "[*] gcc pass 1 build process started"

	gcc_setup

	sed -i '/k prot/agcc_cv_libc_provides_ssp=yes' gcc/configure

	gcc_download_deps
	cd ..

	if [ -d gcc-build ]; then
		echo "[*] removing gcc build directory"
		rm -Rf gcc-build
	fi

	mkdir gcc-build
	cd gcc-build

	echo "[*] Configuring"
	../$GCC_FOLDER/configure --target=$LFS_TGT --prefix=$FINAL_PATH --with-sysroot=$LFS --with-newlib --without-headers --with-local-prefix=$FINAL_PATH --with-native-system-header-dir=$FINAL_PATH/include --disable-nls --disable-shared --disable-multilib --disable-decimal-float --disable-threads --disable-libmudflap --disable-libssp --disable-libgomp --disable-libquadmath --enable-languages=c --with-mpfr-include=$PWD/../$GCC_FOLDER/mpfr/src --with-mpfr-lib=$PWD/mpfr/src/.libs --disable-libatomic || exit 1
	echo "[*] Compiling"
	make $MAKEFLAGS || exit 1

	echo "[*] Installing"
	make $MAKEFLAGS install || exit 1

	ln -sv libgcc.a `$LFS_TGT-gcc -print-libgcc-file-name | sed 's/libgcc/&_eh/'`

	cd ..

	gcc_cleanup

	echo "[*] gcc pass 1 build process finished"
}

build_gcc_pass_2 () {
	echo "[*] gcc pass 2 build process started"

	gcc_setup

	cat gcc/limitx.h gcc/glimits.h gcc/limity.h > `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/include-fixed/limits.h

	gcc_download_deps

	cd ..

	if [ -d gcc-build ]; then
		echo "[*] removing gcc build directory"
		rm -Rf gcc-build
	fi

	mkdir gcc-build
	cd gcc-build

	echo "[*] Configuring"
	../$GCC_FOLDER/configure CFLAGS='-gdwarf-2 -g3 -O0' CXXFLAGS='-gdwarf-2 -g3 -O0' LDFLAGS='-gdwarf-2 -g3 -O0' CFLAGS_FOR_TARGET="-gdwarf-2 -g3 -O3 $FPPROTECT_FLAGS" --prefix=$FINAL_PATH --with-local-prefix=$FINAL_PATH --with-native-system-header-dir=$FINAL_PATH/include --enable-clocale=gnu --enable-shared --enable-threads=posix --enable-__cxa_atexit --enable-languages=c --disable-libstdcxx-pch --disable-multilib --disable-bootstrap --disable-libgomp --with-mpfr-include=$PWD/../$GCC_FOLDER/mpfr/src --with-mpfr-lib=$PWD/mpfr/src/.libs || exit 1

	echo "[*] Compiling"
	make $MAKEFLAGS || exit 1

	echo "[*] Installing"
	make $MAKEFLAGS install || exit 1

	ln -sv gcc $FINAL_PATH/bin/cc

	ln -sv libgcc.a `$LFS_TGT-gcc -print-libgcc-file-name | sed 's/libgcc/&_eh/'`

	cd ..

	echo 'main(){}' > dummy.c
	cc dummy.c || exit 1
	readelf -l a.out | grep ": $FINAL_PATH" | exit 1
	rm dummy.c a.out

	gcc_cleanup

	echo "[*] gcc pass 2 build process finished"
}

install_linux_headers () {
	echo "[*] installing linux headers"

	if [ ! -f linux-3.8.1.tar.xz ]; then
		wget http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.8.1.tar.xz || exit 1
	fi
	if [ -d linux-3.8.1 ]; then
		rm -Rf linux-3.8.1
	fi
	tar -xf linux-3.8.1.tar.xz || exit 1
	if [ ! $KEEP_ARCHIVES ]; then
		rm linux-3.8.1.tar.xz
	fi
	cd linux-3.8.1
	make mrproper || exit 1
	make headers_check || exit 1
	make INSTALL_HDR_PATH=dest headers_install
	cp -rv dest/include/* $FINAL_PATH/include
	cd ..
	if [ ! $DEBUG ]; then
		rm -Rf linux-3.8.1
	fi
}

libc_setup () {
	if [ $FPPROTECT_FLAGS ]; then
		GLIBC_FOLDER=glibc
	else
		GLIBC_FOLDER=glibc-nofpp
	fi

	echo "[*] Checking out / updating fpp libc"
	if [ ! -d $GLIBC_FOLDER ]; then
		if [ $FPPROTECT_FLAGS ]; then
			git clone git://zero-entropy.de/glibc.git $GLIBC_FOLDER || exit 1
		else
			git clone git://sourceware.org/git/glibc.git $GLIBC_FOLDER || exit 1
		fi
		cd $GLIBC_FOLDER
		if [ $FPPROTECT_FLAGS ]; then
			git checkout -b fpp origin/fpp || exit 1
		else
			git checkout 043c748 || exit 1
		fi
		cd ..
	fi

	cd $GLIBC_FOLDER
	if [ $FPPROTECT_FLAGS ]; then
		git pull origin fpp
	fi

	cd ..

	if [ -d glibc-build ]; then
		echo "[*] removing glibc build directory"
		rm -Rf glibc-build
	fi

	mkdir glibc-build
	cd glibc-build
}

build_libc_pass_1 () {
	echo "[*] libc pass 1 build process started"

	libc_setup

	echo "build-programs=no" > configparms

	echo "[*] Configuring"
	../$GLIBC_FOLDER/configure --prefix=$FINAL_PATH --host=$LFS_TGT --build=x86_64-unknown-linux-gnu --disable-profile --enable-kernel=2.6.25 --with-headers=$FINAL_PATH/include libc_cv_forced_unwind=yes libc_cv_ctors_header=yes libc_cv_c_cleanup=yes CFLAGS="-O1 -ggdb $FPPROTECT_FLAGS" LDFLAGS="-ggdb"  || exit 1

	echo "[*] Compiling"
	make $MAKEFLAGS || exit 1

	echo "[*] Installing"
	make $MAKEFLAGS install || exit 1

	cd ..

	echo "[*] Checking compiler output"
	echo 'main(){}' > dummy.c
	$LFS_TGT-gcc dummy.c
	readelf -l a.out | grep ": $FINAL_PATH" || exit 1
	rm -v dummy.c a.out

	if [ ! $DEBUG ]; then
		echo "[*] removing libc build directory"
		rm -Rf glibc-build
	fi

	echo "[*] glibc pass 1 build process finished"
}

build_libc_pass_2 () {
	echo "[*] libc pass 2 build process started"

	libc_setup

	#TODO programs needed?
	#echo "build-programs=no" > configparms

	echo "[*] Configuring"
	../$GLIBC_FOLDER/configure --prefix=$FINAL_PATH --build=x86_64-unknown-linux-gnu --disable-profile --enable-kernel=2.6.25 --with-headers=$FINAL_PATH/include CFLAGS="-O1 -ggdb $FPPROTECT_FLAGS" LDFLAGS="-ggdb" || exit 1

	echo "[*] Compiling"
	make $MAKEFLAGS || exit 1

	echo "[*] Installing"
	make $MAKEFLAGS install || exit 1

	cd ..

	echo "[*] Checking compiler output"
	echo 'main(){}' > dummy.c
	cc dummy.c || exit 1
	readelf -l a.out | grep ": $FINAL_PATH" | exit 1
	rm dummy.c a.out

	if [ ! $DEBUG ]; then
		echo "[*] removing libc build directory"
		rm -Rf glibc-build
	fi

	echo "[*] glibc pass 2 build process finished"
}

build_nginx () {
	echo "[*] nginx build process started"

	if [ ! -f nginx-1.4.1.tar.gz ]; then
		echo "[*] Downloading nginx"
		wget http://nginx.org/download/nginx-1.4.1.tar.gz || exit 1
	fi
	if [ -d nginx-1.4.1 ]; then
		rm -Rf nginx-1.4.1
	fi

	tar -xf nginx-1.4.1.tar.gz || exit 1
	if [ ! $KEEP_ARCHIVES ]; then
		rm nginx-1.4.1.tar.gz
	fi

	cd nginx-1.4.1

	echo "[*] Configuring"
	CFLAGS="$FPPROTECT_FLAGS -ggdb" ./configure --without-http_rewrite_module --without-http_gzip_module --prefix=$FINAL_PATH || exit 1

	echo "[*] Compiling"
	make $MAKEFLAGS || exit 1

	echo "[*] Installing"
	make $MAKEFLAGS install || exit 1

	cd ..

	echo "[*] nginx build process finished"
	if [ ! $DEBUG ]; then
		rm -Rf nginx-1.4.1
	fi
}

DATEFILE="$(date '+%C%y-%m-%d-%H-%M').log"

echo "Start" >> $DATEFILE
date >> $DATEFILE
setup_env
echo "dirs" >> $DATEFILE
date >> $DATEFILE
setup_dirs
echo "binutils" >> $DATEFILE
date >> $DATEFILE
build_binutils_pass_1
echo "gcc1" >> $DATEFILE
date >> $DATEFILE
build_gcc_pass_1
echo "linux headers" >> $DATEFILE
date >> $DATEFILE
install_linux_headers
echo "libc1" >> $DATEFILE
date >> $DATEFILE
build_libc_pass_1
echo "gcc2" >> $DATEFILE
date >> $DATEFILE
build_gcc_pass_2
echo "libc2" >> $DATEFILE
date >> $DATEFILE
build_libc_pass_2
echo "nginx" >> $DATEFILE
date >> $DATEFILE
build_nginx
echo "Finished" >> $DATEFILE
date >> $DATEFILE

