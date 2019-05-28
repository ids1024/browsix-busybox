BUSYBOX_CFLAGS := -nostdlib --target=wasm32 -Os -nostdinc -isystem $(PWD)/musl/include -isystem $(PWD)/musl/arch/wasm32 -isystem $(PWD)/musl/obj/include

BUSYBOX_LDFLAGS := $(BUSYBOX_CFLAGS) -Wl,--no-entry -Wl,--export=main -Wl,--export=__init_libc -Wl,--export=__libc_start_init -Wl,--export=exit -Wl,--allow-undefined-file=$(PWD)/functions -Wl,--import-memory -Wl,--shared-memory -Wl,--max-memory=67108864 -L$(PWD)/musl/lib -L$(PWD)/compiler-rt/build/lib/generic -Wl,--whole-archive -lc -lclang_rt.builtins-wasm32 -Wl,-error-limit=0

all: dist

serve: dist
	cd dist && python2 -m SimpleHTTPServer 8080

dist: busybox/busybox browsix
	rm -rf dist
	mkdir -p dist/fs/bin dist/fs/usr/bin
	\
	cp -r browsix/app/* dist
	cp -r browsix/bower_components dist
	cp -r browsix/node_modules/xterm/dist dist/xterm
	cp browsix/fs/usr/bin/sh browsix/fs/usr/bin/node browsix/fs/usr/bin/ld dist/fs/usr/bin
	\
	cp busybox/busybox dist/fs/usr/bin/busybox
	cp browsix/fs/bin/sh dist/fs/bin/sh
	cp -r browsix/fs/boot dist/fs
	\
	for i in $$(cat busybox/busybox.links) ; \
	do \
		echo '#!/bin/sh' > dist/fs/usr/bin/$$(basename $$i) ; \
		echo /usr/bin/busybox $$(basename $$i) '$$@' >> dist/fs/usr/bin/$$(basename $$i) ; \
	done
	\
	browsix/xhrfs-index dist/fs > dist/fs/index.json

busybox/busybox: musl/lib/libc.a
	$(MAKE) -C busybox CC=clang SKIP_STRIP=y CFLAGS="$(BUSYBOX_CFLAGS)" LDFLAGS="$(BUSYBOX_LDFLAGS)"
	$(MAKE) -C busybox busybox.links

browsix:
	cd browsix && \
	npm install && \
	./node_modules/.bin/bower install && \
	./node_modules/.bin/gulp app:build app:styles app:elements app:images

musl/lib/libc.a: FORCE compiler-rt/build/lib/generic/libclang_rt.builtins-wasm32.a musl/config.mak
	cd musl && make

musl/config.mak: musl-config.mak
	cp $< $@

musl/obj/include/bits/alltypes.h: musl/arch/wasm32/bits/alltypes.h.in musl/config.mak
	cd musl && make obj/include/bits/alltypes.h

compiler-rt/build/Makefile:
	mkdir compiler-rt/build
	cd compiler-rt/build && cmake -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_SYSTEM_NAME="Generic" --target=wasm32 -DCOMPILER_RT_BAREMETAL_BUILD=TRUE -DCOMPILER_RT_DEFAULT_TARGET_TRIPLE=wasm32 -DCOMPILER_RT_BUILD_SANITIZERS=OFF -DCOMPILER_RT_BUILD_XRAY=OFF -DCOMPILER_RT_BUILD_LIBFUZZER=OFF -DCOMPILER_RT_BUILD_PROFILE=OFF -DCAN_TARGET_wasm32=1 -DCMAKE_C_FLAGS="-nostdinc -isystem $(PWD)/musl/include -isystem $(PWD)/musl/arch/wasm32 -isystem $(PWD)/musl/obj/include" ..

compiler-rt/build/lib/generic/libclang_rt.builtins-wasm32.a: FORCE compiler-rt/build/Makefile musl/obj/include/bits/alltypes.h
	$(MAKE) -C compiler-rt/build

clean:
	$(MAKE) -C busybox clean
	$(MAKE) -C browsix clean
	$(MAKE) -C musl clean
	rm -rf compiler-rt/build
	rm -rf dist

# https://stackoverflow.com/questions/33349078/make-execute-2nd-rule-only-if-1st-changed-file
FORCE: ;

.PHONY: all dist serve busybox browsix musl
