#!/bin/sh

set -e

export PATH=$PWD/emscripten:$PATH
export HOME=$PWD

cd busybox
	emmake make CROSS_COMPILE= CC=emcc SKIP_STRIP=y
cd ..
