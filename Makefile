SHELL = /bin/bash

#TODO PHONY
#TODO temporary folder for gcc1
#TODO programs needed? (libc2)
DESTDIR=/tools
LFS_TGT=x86_64-lfs-linux-gnu
LFS=$(HOME)/workspace/fpp

BINUTILS_MIRROR=ftp://sourceware.org/pub/binutils/snapshots/binutils-2.23.52.tar.bz2
BINUTILS_ARCHIVE=$(notdir $(BINUTILS_MIRROR))
GMP_MIRROR=ftp://ftp.gmplib.org/pub/gmp-5.1.1/gmp-5.1.1.tar.xz
GMP_ARCHIVE=$(notdir $(GMP_MIRROR))
MPC_MIRROR=http://www.multiprecision.org/mpc/download/mpc-1.0.1.tar.gz
MPC_ARCHIVE=$(notdir $(MPC_MIRROR))
MPFR_MIRROR=http://www.mpfr.org/mpfr-3.1.1/mpfr-3.1.1.tar.xz
MPFR_ARCHIVE=$(notdir $(MPFR_MIRROR))
LINUX_MIRROR=http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.8.1.tar.xz
LINUX_ARCHIVE=$(notdir $(LINUX_MIRROR))
#GCC_ARCHIVES=$(GMP_ARCHIVE) $(MPC_ARCHIVE) $(MPFR_ARCHIVE)
#ALL_ARCHIVES=$(BINUTILS_ARCHIVE) $(GCC_ARCHIVES)

.PHONY: all
all: nginx_fpp

.PHONY: install
install: all
	$(error install target not yet implemented)

.PHONY: nginx_fpp nginx
nginx_fpp nginx: nginx% : libc2%
	@echo $@

$(DESTDIR)/include: linux_src
	$(MAKE) -C $< mrproper
	$(MAKE) -C $< headers_check
	$(MAKE) -C $< INSTALL_HDR_PATH=dest headers_install
	cp -rv $</dest/include $(DESTDIR)/include

linux_src: $(LINUX_ARCHIVE)
	tar -xf $<
	mv $(basename $(basename $<)) $@

gcc1 gcc1_fpp: $(DESTDIR)/bin/$(LFS_TGT)-ld
gcc1 gcc2: gcc_src/gmp gcc_src/mpc gcc_src/mpfr
gcc1_fpp gcc2_fpp: gcc_src_fpp/gmp gcc_src_fpp/mpc gcc_src_fpp/mpfr
gcc2 gcc2_fpp: gcc2% : libc1%

gcc_src/gmp: $(GMP_ARCHIVE) gcc_src
gcc_src/mpc: $(MPC_ARCHIVE) gcc_src
gcc_src/mpfr: $(MPFR_ARCHIVE) gcc_src
gcc_src_fpp/gmp: $(GMP_ARCHIVE) gcc_src_fpp
gcc_src_fpp/mpc: $(MPC_ARCHIVE) gcc_src_fpp
gcc_src_fpp/mpfr: $(MPFR_ARCHIVE) gcc_src_fpp

$(LINUX_ARCHIVE):
	wget -c $(LINUX_MIRROR)

$(BINUTILS_ARCHIVE):
	wget -c $(BINUTILS_MIRROR)

$(GMP_ARCHIVE):
	wget -c $(GMP_MIRROR)

gcc_src/gmp gcc_src/mpc gcc_src/mpfr gcc_src_fpp/gmp gcc_src_fpp/mpc gcc_src_fpp/mpfr:
	tar -xf $<
	mv $(basename $(basename $<)) $@


$(MPC_ARCHIVE):
	wget -c $(MPC_MIRROR)

$(MPFR_ARCHIVE):
	wget -c $(MPFR_MIRROR)

binutils_src: $(BINUTILS_ARCHIVE)
	tar -xf $(BINUTILS_ARCHIVE)
	mv $(basename $(basename $(BINUTILS_ARCHIVE))) $@

$(DESTDIR):
	mkdir -p $(LFS)$(DESTDIR)
	sudo ln -sv $(LFS)$(DESTDIR) $(DESTDIR)
	mkdir -v $(DESTDIR)/lib && ln -sv lib $(DESTDIR)/lib64

$(DESTDIR)/bin/$(LFS_TGT)-ld: binutils_build $(DESTDIR)
	$(MAKE) -C binutils_build install

binutils_build: binutils_src $(DESTDIR)
	mkdir $@
	cd $@ && ../binutils_src/configure CFLAGS='-pipe' --prefix=$(DESTDIR) --with-sysroot=$(LFS) --with-lib-path=$(DESTDIR)/lib --target=$(LFS_TGT) --disable-nls --disable-werror
	$(MAKE) -C $@

define gcc_src
gcc_src$(findstring _fpp,$@)
endef

gcc_src gcc_src_fpp:
	if [[ "$@" == *"fpp"* ]]; then \
		git clone git://zero-entropy.de/gcc.git $@ && \
		cd $@ && git checkout -b fpprotect origin/fpprotect_gimple; \
	else \
		git clone git://gcc.gnu.org/git/gcc.git $@ && \
		cd $@ && git checkout 31d89c5; \
	fi
	cd $(gcc_src) && for file in $(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h); do \
		cp -uv $$file{,.orig}; \
		sed -e "s@/lib\(64\)\?\(32\)\?/ld@$(DESTDIR)&@g" \
			-e "s@/usr@$(DESTDIR)@g" $$file.orig > $$file; \
		echo "\
#undef STANDARD_STARTFILE_PREFIX_1\
#undef STANDARD_STARTFILE_PREFIX_2\
#define STANDARD_STARTFILE_PREFIX_1 \"$(DESTDIR)/lib/\"\
#define STANDARD_STARTFILE_PREFIX_2 \"\"" >> $$file;\
		touch $$file.orig;\
	done

gcc%:
#revert the src folder
#	cd $(gcc_src) && git clean -fdx && git reset --hard
#
	cd $(gcc_src) && git checkout -- gcc/configure
	cd $(gcc_src) && sed -i 's/BUILD_INFO=info/BUILD_INFO=/' gcc/configure
	if [[ "$@" == *"1"* ]]; then \
		cd $(gcc_src) && sed -i '/k prot/agcc_cv_libc_provides_ssp=yes' gcc/configure; \
	else \
		cd $(gcc_src) && cat gcc/limitx.h gcc/glimits.h gcc/limity.h > `dirname $$($(LFS_TGT)-gcc -print-libgcc-file-name)`/include-fixed/limits.h; \
	fi

	mkdir $@

	if [[ "$@" == *"1"* ]]; then \
		cd $@ && ../$(gcc_src)/configure CFLAGS='-pipe' --target=$(LFS_TGT) --prefix=$(DESTDIR) --with-sysroot=$(LFS) --with-newlib --without-headers --with-local-prefix=$(DESTDIR) --with-native-system-header-dir=$(DESTDIR)/include --disable-nls --disable-shared --disable-multilib --disable-decimal-float --disable-threads --disable-libmudflap --disable-libssp --disable-libgomp --disable-libquadmath --enable-languages=c --with-mpfr-include=$$PWD/../$(gcc_src)/mpfr/src --with-mpfr-lib=$$PWD/mpfr/src/.libs --disable-libatomic; \
	else \
		cd $@ && ../$(gcc_src)/configure CFLAGS='-pipe -gdwarf-2 -g3 -O0' CXXFLAGS='-pipe -gdwarf-2 -g3 -O0' LDFLAGS='-gdwarf-2 -g3 -O0' CFLAGS_FOR_TARGET="-pipe -gdwarf-2 -g3 -O3 -ffp-protect" --prefix=$(DESTDIR) --with-local-prefix=$(LFS) --with-native-system-header-dir=$(DESTDIR)/include --enable-clocale=gnu --enable-shared --enable-threads=posix --enable-__cxa_atexit --enable-languages=c --disable-libstdcxx-pch --disable-multilib --disable-bootstrap --disable-libgomp --with-mpfr-include=$$PWD/../$(gcc_src)/mpfr/src --with-mpfr-lib=$$PWD/mpfr/src/.libs; \
	fi

	$(MAKE) -C $@

	$(MAKE) -C $@ install

	#pass2
#	ln -sv gcc $FINAL_PATH/bin/cc
#
	echo '$@' >> tst.txt
	echo `$(LFS_TGT)-gcc -print-libgcc-file-name | sed 's/libgcc/&_eh/'` >> tst.txt
	ln -sv libgcc.a `$(LFS_TGT)-gcc -print-libgcc-file-name | sed 's/libgcc/&_eh/'`

libc_src libc_src_fpp:
	if [[ "$@" == *"fpp"* ]]; then \
		git clone git://zero-entropy.de/glibc.git $@ && \
		cd $@ && git checkout -b fpp origin/fpp; \
	else \
		git clone git://sourceware.org/git/glibc.git $@ && \
		cd $@ && git checkout 043c748; \
	fi

libc%: libc_src% gcc% $(DESTDIR)/include
	mkdir $@

	cd $@ && if [[ "$@" == *"1"* ]]; then \
		echo "build-programs=no" > configparms && \
		../$</configure --prefix=$(DESTDIR) --host=$(LFS_TGT) --build=x86_64-unknown-linux-gnu --disable-profile --enable-kernel=2.6.25 --with-headers=$(DESTDIR)/include libc_cv_forced_unwind=yes libc_cv_ctors_header=yes libc_cv_c_cleanup=yes CFLAGS="-pipe -O3 -ggdb -ffp-protect" LDFLAGS="-ggdb"; \
	else \
		../$</configure --prefix=$(DESTDIR) --build=x86_64-unknown-linux-gnu --disable-profile --enable-kernel=2.6.25 --with-headers=$FINAL_PATH/include CFLAGS="-pipe -O3 -ggdb -ffp-protect" LDFLAGS="-ggdb"; \
	fi

	$(MAKE) -C $@

	$(MAKE) -C $@ install

	echo 'main(){}' > dummy.c
	$(DESTDIR)/bin/$(LFS_TGT)-gcc dummy.c
	readelf -l a.out | grep ": $(DESTDIR)" || exit 1
	rm -v dummy.c a.out

#build_nginx () {
#	echo "[*] nginx build process started"
#
#	if [ ! -f nginx-1.4.1.tar.gz ]; then
#		echo "[*] Downloading nginx"
#		wget http://nginx.org/download/nginx-1.4.1.tar.gz || exit 1
#	fi
#	if [ -d nginx-1.4.1 ]; then
#		rm -Rf nginx-1.4.1
#	fi
#
#	tar -xf nginx-1.4.1.tar.gz || exit 1
#	if [ ! $KEEP_ARCHIVES ]; then
#		rm nginx-1.4.1.tar.gz
#	fi
#
#	cd nginx-1.4.1
#
#	echo "[*] Configuring"
#	CFLAGS="$FPPROTECT_FLAGS -ggdb -O3 -pipe" ./configure --without-http_rewrite_module --without-http_gzip_module --prefix=$FINAL_PATH || exit 1
#
#	echo "[*] Compiling"
#	make $MAKEFLAGS || exit 1
#
#	echo "[*] Installing"
#	make $MAKEFLAGS install || exit 1
#
#	cd ..
#
#	echo "[*] nginx build process finished"
#	if [ ! $DEBUG ]; then
#		rm -Rf nginx-1.4.1
#	fi
#}
#
#DATEFILE="$(date '+%C%y-%m-%d-%H-%M').log"
#
#echo "Start" >> $DATEFILE
#date >> $DATEFILE
#setup_env
#echo "dirs" >> $DATEFILE
#date >> $DATEFILE
#setup_dirs
#echo "binutils" >> $DATEFILE
#date >> $DATEFILE
#build_binutils_pass_1
#echo "gcc1" >> $DATEFILE
#date >> $DATEFILE
#build_gcc_pass_1
#echo "linux headers" >> $DATEFILE
#date >> $DATEFILE
#install_linux_headers
#echo "libc1" >> $DATEFILE
#date >> $DATEFILE
#build_libc_pass_1
#echo "gcc2" >> $DATEFILE
#date >> $DATEFILE
#build_gcc_pass_2
#echo "libc2" >> $DATEFILE
#date >> $DATEFILE
#build_libc_pass_2
#echo "nginx" >> $DATEFILE
#date >> $DATEFILE
#build_nginx
#echo "Finished" >> $DATEFILE
#date >> $DATEFILE
#
