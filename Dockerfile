FROM tim03/baseimage
LABEL maintainer Chen, Wenli <chenwenli@chenwenli.com>

WORKDIR /usr/src
ADD https://openssl.org/source/openssl-1.0.2k.tar.gz .
COPY md5sums .
RUN md5sum -c md5sums
RUN \
	tar xvf openssl-1.0.2k.tar.gz && \
	mv openssl-1.0.2k openssl && \
	cd openssl && \
	./config --prefix=/usr         \
         --openssldir=/etc/ssl \
         --libdir=lib          \
         shared                \
         zlib-dynamic && \
	make depend     && \
	make -j1	&& \
	make -j1 test   && \
	sed -i 's# libcrypto.a##;s# libssl.a##' Makefile && \
	make MANDIR=/usr/share/man MANSUFFIX=ssl install && \
	cd /usr/src && \
	rm -rf openssl
