rm -f Makefile config.status config.h openvpn
XAUTOCONF=--enable-password-save \
OPENSSL_DIR=$PWD/../win32/openssl-0.9.8r \
LZO_DIR=$PWD/../win32/lzo-2.04 \
PKCS11_HELPER_DIR=$PWD/../win32/pkcs11-helper-1.08 \
CC=i586-mingw32msvc-gcc \
bash -x install-win32/makeopenvpn
