SHELL = /bin/bash

#TODO PHONY
#TODO temporary folder for gcc1
#TODO programs needed? (libc2)
#TODO remove fpp/nonfpp build targets
# -> use a variable instead so it can be called like FPP="no" make
FPP_DESTDIR=$(PWD)/install
FPP_TGT=x86_64-lfs-linux-gnu
FPP_SYSROOT=$(PWD)/fpp-tmp$(FPP_DESTDIR)
FPP_PATH:=$(FPP_DESTDIR)/bin:$(PATH)

USER_CFLAGS=-pipe -ggdb -O0

GCC_CONFIGURE_OPTS=CFLAGS='$(USER_CFLAGS)' \
	--prefix=$(FPP_DESTDIR) \
	--with-native-system-header-dir=$(FPP_DESTDIR)/include \
	--disable-multilib \
	--disable-libgomp \
	--with-mpfr-include=$$PWD/../$(gcc_src)/mpfr/src \
	--with-mpfr-lib=$$PWD/mpfr/src/.libs \
	--enable-languages=c
GCC1_CONFIGURE_OPTS=--target=$(FPP_TGT) \
	--with-sysroot=$(FPP_SYSROOT) \
	--with-newlib \
	--without-headers \
	--with-local-prefix=$(FPP_DESTDIR) \
	--disable-nls \
	--disable-shared \
	--disable-decimal-float \
	--disable-threads \
	--disable-libmudflap \
	--disable-libssp \
	--disable-libquadmath \
	--disable-libatomic
GCC2_CONFIGURE_OPTS=CXXFLAGS='$(USER_CFLAGS)' \
	CFLAGS_FOR_TARGET='$(USER_CFLAGS) -ffp-protect' \
	--with-local-prefix=$(FPP_SYSROOT) \
	--enable-clocale=gnu \
	--enable-shared \
	--enable-threads=posix \
	--enable-__cxa_atexit \
	--disable-libstdcxx-pch \
	--disable-bootstrap
NGINX_CONFIGURE_OPTS=--without-http_rewrite_module \
	--without-http_gzip_module \
	--prefix=$(FPP_DESTDIR)
BINUTILS_CONFIGURE_OPTS=CFLAGS='$(USER_CFLAGS)' \
	--prefix=$(FPP_DESTDIR) \
	--with-sysroot=$(FPP_SYSROOT) \
	--with-lib-path=$(FPP_DESTDIR)/lib \
	--target=$(FPP_TGT) \
	--disable-nls \
	--disable-werror
GLIBC_CONFIGURE_OPTS=--prefix=$(FPP_DESTDIR) \
	--with-headers=$(FPP_DESTDIR)/include \
	--disable-profile \
	--enable-kernel=2.6.25 \
	CFLAGS='$(patsubst -O0,-O1,$(USER_CFLAGS)) -ffp-protect'
GLIBC1_CONFIGURE_OPTS=--host=$(FPP_TGT) \
	--build=x86_64-unknown-linux-gnu \
	libc_cv_forced_unwind=yes \
	libc_cv_ctors_header=yes \
	libc_cv_c_cleanup=yes
GLIBC2_CONFIGURE_OPTS=--build=x86_64-unknown-linux-gnu

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
NGINX_MIRROR=http://nginx.org/download/nginx-1.4.1.tar.gz
NGINX_ARCHIVE=$(notdir $(NGINX_MIRROR))
GCC_ARCHIVES=$(GMP_ARCHIVE) $(MPC_ARCHIVE) $(MPFR_ARCHIVE)
ALL_ARCHIVES=$(BINUTILS_ARCHIVE) $(GCC_ARCHIVES) $(LINUX_ARCHIVE) $(NGINX_ARCHIVE)

.PHONY: all
all: nginx_fpp

nginx_fpp nginx: nginx% : nginx_src libc2%
	cp -R $< $@
	cd $@ && PATH=$(FPP_PATH) CFLAGS='-ffp-protect $(USER_CFLAGS)' ./configure \
		$(NGINX_CONFIGURE_OPTS)
	PATH=$(FPP_PATH) $(MAKE) -C $@
	PATH=$(FPP_PATH) $(MAKE) -C $@ install

$(FPP_DESTDIR)/include: linux_build
	cp -rv $</dest/include $(FPP_DESTDIR)/

linux_build: linux_src
	if [ ! -d $@ ]; then \
		mkdir $@; \
	fi
	$(MAKE) -C $< O=../$@ mrproper
	$(MAKE) -C $< O=../$@ headers_check
	$(MAKE) -C $< O=../$@ INSTALL_HDR_PATH=dest headers_install

linux_src: $(LINUX_ARCHIVE)
	tar -xf $<
	mv $(basename $(basename $<)) $@

nginx_src: $(NGINX_ARCHIVE)
	tar -xf $<
	mv $(basename $(basename $<)) $@

gcc1 gcc1_fpp: $(FPP_DESTDIR)/bin/$(FPP_TGT)-ld
gcc1 gcc2: gcc_src/gmp gcc_src/mpc gcc_src/mpfr
gcc1_fpp gcc2_fpp: gcc_src_fpp/gmp gcc_src_fpp/mpc gcc_src_fpp/mpfr
gcc2 gcc2_fpp: gcc2% : libc1%
libc1 libc2: libc_src gcc
libc1_fpp libc2_fpp: libc_src_fpp
libc1 libc1_fpp libc2 libc2_fpp: libc%: gcc% $(FPP_DESTDIR)/include

gcc_src/gmp: $(GMP_ARCHIVE) gcc_src
gcc_src/mpc: $(MPC_ARCHIVE) gcc_src
gcc_src/mpfr: $(MPFR_ARCHIVE) gcc_src
gcc_src_fpp/gmp: $(GMP_ARCHIVE) gcc_src_fpp
gcc_src_fpp/mpc: $(MPC_ARCHIVE) gcc_src_fpp
gcc_src_fpp/mpfr: $(MPFR_ARCHIVE) gcc_src_fpp

$(LINUX_ARCHIVE):
	wget -c $(LINUX_MIRROR)

$(NGINX_ARCHIVE):
	wget -c $(NGINX_MIRROR)

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

$(FPP_DESTDIR): $(FPP_SYSROOT)$(FPP_DESTDIR)
	ln -sfnv $(FPP_SYSROOT)$(FPP_DESTDIR) $(FPP_DESTDIR)

$(FPP_SYSROOT)$(FPP_DESTDIR):
	mkdir -p $(FPP_SYSROOT)$(FPP_DESTDIR)

$(FPP_DESTDIR)/lib: $(FPP_DESTDIR)

$(FPP_DESTDIR)/lib:
	if [ ! -d $@ ]; then \
		mkdir -p $@; \
	fi

$(FPP_DESTDIR)/lib64: $(FPP_DESTDIR) $(FPP_DESTDIR)/lib
	ln -sfnv lib $(FPP_DESTDIR)/lib64

$(FPP_DESTDIR)/bin/$(FPP_TGT)-ld: binutils_build $(FPP_DESTDIR)/lib64
	$(MAKE) -C binutils_build install

binutils_build: binutils_src
	if [ ! -d $@ ]; then \
		mkdir $@ && \
		cd $@ && ../binutils_src/configure \
			$(BINUTILS_CONFIGURE_OPTS); \
	fi
	$(MAKE) -C $@

define gcc_src
gcc_src$(findstring _fpp,$@)
endef

gcc_src gcc_src_fpp:
	if [ -d $@ ]; then \
		cd $@ && git clean -fdx && git reset --hard && git pull; \
	else \
		git clone git://zero-entropy.de/gcc.git $@ && \
		if [[ "$@" == *"fpp"* ]]; then \
			cd $@ && git checkout -b fpprotect origin/fpprotect_gimple; \
		else \
			cd $@ && git checkout 31d89c5; \
		fi; \
	fi
	cd $@ && for file in $$(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h); do \
		cp -uv $$file{,.orig}; \
		sed -e "s@/lib\(64\)\?\(32\)\?/ld@$(FPP_DESTDIR)&@g" \
			-e "s@/usr@$(FPP_DESTDIR)@g" $$file.orig > $$file; \
		echo -e "\n#undef STANDARD_STARTFILE_PREFIX_1\n#undef STANDARD_STARTFILE_PREFIX_2\n#define STANDARD_STARTFILE_PREFIX_1 \"$(FPP_DESTDIR)/lib/\"\n#define STANDARD_STARTFILE_PREFIX_2 \"\"" >> $$file;\
		touch $$file.orig;\
	done

gcc%:
	cd $(gcc_src) && git checkout -- gcc/configure
	cd $(gcc_src) && sed -i 's/BUILD_INFO=info/BUILD_INFO=/' gcc/configure
	if [[ "$@" == *"1"* ]]; then \
		cd $(gcc_src) && sed -i '/k prot/agcc_cv_libc_provides_ssp=yes' gcc/configure; \
	else \
		cd $(gcc_src) && cat gcc/limitx.h gcc/glimits.h gcc/limity.h > `dirname $$($(FPP_TGT)-gcc -print-libgcc-file-name)`/include-fixed/limits.h; \
	fi

	if [ -d $@ ]; then \
		rm -R $@; \
	fi
	mkdir $@

	if [[ "$@" == *"1"* ]]; then \
		cd $@ && ../$(gcc_src)/configure \
			$(GCC_CONFIGURE_OPTS) \
			$(GCC1_CONFIGURE_OPTS); \
	else \
		cd $@ && PATH=$(FPP_PATH) ../$(gcc_src)/configure \
			$(GCC_CONFIGURE_OPTS) \
			$(GCC2_CONFIGURE_OPTS); \
	fi

	if [[ "$@" == *"1"* ]]; then \
		$(MAKE) -C $@; \
	else \
		PATH=$(FPP_PATH) $(MAKE) -C $@; \
	fi

	if [[ "$@" == *"1"* ]]; then \
		$(MAKE) -C $@ install; \
	else \
		PATH=$(FPP_PATH) $(MAKE) -C $@ install; \
	fi

	if [[ "$@" == *"2"* ]]; then \
		ln -sfnv gcc $(FPP_DESTDIR)/bin/cc; \
	fi

	ln -sfnv libgcc.a `$(FPP_TGT)-gcc -print-libgcc-file-name | sed 's/libgcc/&_eh/'`

libc_src libc_src_fpp:
	if [[ "$@" == *"fpp"* ]]; then \
		git clone git://zero-entropy.de/glibc.git $@ && \
		cd $@ && git checkout -b fpp origin/fpp; \
	else \
		git clone git://sourceware.org/git/glibc.git $@ && \
		cd $@ && git checkout 043c748; \
	fi
	cd $@ && patch -p1 < ../gcc_hsep_vsep.patch

libc%:
	if [ -d $@ ]; then \
		rm -R $@; \
	fi
	mkdir $@

	cd $@ && if [[ "$@" == *"1"* ]]; then \
		echo "build-programs=no" > configparms && \
		PATH=$(FPP_PATH) ../$</configure \
			$(GLIBC_CONFIGURE_OPTS) \
			$(GLIBC1_CONFIGURE_OPTS); \
	else \
		PATH=$(FPP_PATH) ../$</configure \
			$(GLIBC_CONFIGURE_OPTS) \
			$(GLIBC2_CONFIGURE_OPTS); \
	fi

	PATH=$(FPP_PATH) $(MAKE) -C $@

	PATH=$(FPP_PATH) $(MAKE) -C $@ install

	echo 'main(){}' > dummy.c
	PATH=$(FPP_PATH) $(FPP_TGT)-gcc dummy.c
	readelf -l a.out | grep ": $(FPP_DESTDIR)"
	rm -v dummy.c a.out

.PHONY: clean
clean: clean-archives clean-build clean-src

.PHONY: clean-archives
clean-archives:
	- rm $(ALL_ARCHIVES)

.PHONY: clean-build
clean-build:
	- rm -Rf binutils_build
	- rm -Rf gcc1_fpp gcc2_fpp
	- rm -Rf gcc1 gcc2
	- rm -Rf libc1_fpp libc2_fpp
	- rm -Rf libc1 libc2
	- rm -Rf linux_build
	- rm -Rf nginx_fpp nginx

.PHONY: clean-src
clean-src:
	- rm -Rf binutils_src
	- rm -Rf gcc_src_fpp
	- rm -Rf gcc_src
	- rm -Rf libc_src_fpp
	- rm -Rf libc_src
	- rm -Rf linux_src
	- rm -Rf nginx_src

