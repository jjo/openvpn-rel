#!/bin/sh

patch -r- -p1 -s -N < ../../openvpn/install-win32/openssl/openssl098.patch

# jjo: re-
# copy/pasted from http://asmw.de/?p=36, modified and fixed based on  http://www.mail-archive.com/openssl-dev@openssl.org/msg19713.html
# and added sane CFlags, the dlls won't run probably on < pentium4 + sse2 CPUs
# Lazify things a little
export cross="i586-mingw32msvc-"
# options we gonna use
CONFIG_OPTS="no-capieng no-cms no-gmp no-idea no-jpake no-krb5 no-mdc2 no-montasm no-rc5 no-rfc3779 no-seed no-hw no-engine"
# Generate the dll definitions
perl util/mkdef.pl ${CONFIG_OPTS} libeay 32 > ms/libeay32.def
perl util/mkdef.pl ${CONFIG_OPTS} ssleay 32 > ms/ssleay32.def

# Remove a check which effs up the cross-sompile
sed -e '/^$IsMK1MF=1/d' -e 's/-O3 -march=i486//g' -i Configure
#fix up gcc 4.x
sed -e 's/static type/type/' -i e_os2.h

# Configure + CFLAGS (-DOPENSSL_NO_HW is needed otherwise the dlls break)
./Configure ${CONFIG_OPTS} shared mingw -O2 -march=pentium4 -mtune=pentium4 -Wl,--export-all -msse -mmmx -msse2 -DOPENSSL_NO_HW

# Fix up the tools and libs
sed -i -e "s/^EX_LIBS=\(.*\)/EX_LIBS=\1 -lws2_32 -lgdi32/" Makefile
sed -i -e "s/^CC=.*/CC=${cross}gcc/" Makefile
sed -i -e "s/^RANLIB=.*/RANLIB=${cross}ranlib/" Makefile
sed -i -e "s/^AR=.*/AR=${cross}ar r/" Makefile
sed -i -e "s/^ARD=.*/ARD=${cross}ar d/" Makefile

# Build the whole shebang
make build_libs build_apps "$@"

[ ! -d "out" ] &&  mkdir out

cp apps/openssl.exe out/
cp *.a out/
${cross}dllwrap --dllname libeay32.dll --output-lib out/libeay32.a --def ms/libeay32.def out/libcrypto.a -lwsock32 -lgdi32
${cross}dllwrap --dllname libssl32.dll --output-lib out/libssl32.a --def ms/ssleay32.def out/libssl.a out/libeay32.a
cp *.dll out/
# strip'em
${cross}strip out/*.dll out/*.exe
