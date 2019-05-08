#!/bin/sh
export PATH=$PWD/emscripten:$PATH
export CTARGET=js

cd aports/main/busybox
abuild
