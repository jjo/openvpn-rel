#!/bin/bash -x
./configure --host=i586-mingw32msvc --build=i386-linux \
        MAN2HTML=true \
        --disable-crypto-engine-gnutls \
        --disable-crypto-engine-nss \
        PKG_CONFIG=true \
	OPENSSL_CFLAGS="-I$PWD/../openssl-0.9.8r/include" \
	OPENSSL_LIBS="-L$PWD/../openssl-0.9.8r/out -leay32"

