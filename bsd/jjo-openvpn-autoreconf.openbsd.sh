#!/bin/sh -x
AUTOCONF_VERSION=2.62 AUTOMAKE_VERSION=1.9 autoreconf-2.62 -i -v
./configure --disable-lzo
