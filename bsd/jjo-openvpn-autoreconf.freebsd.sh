#!/bin/sh -x
AUTOCONF_VERSION=2.68 AUTOMAKE_VERSION=1.11 autoreconf -i -v
./configure --disable-lzo
