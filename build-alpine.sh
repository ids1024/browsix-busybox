#!/bin/sh
export PATH=$PWD/emscripten:$PATH
export CTARGET=js
export PACKAGER_PRIVKEY=$PWD/abuild-key.rsa
SRCDEST=$PWD/distfiles

if [ ! -e $PACKEGER_PRIVKEY ]; then
	echo $PACKEGER_PRIVKEY | abuild-keygen
fi

cd aports/main/busybox
abuild -s $SRCDEST -r
