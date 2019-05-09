export PATH := $(shell pwd)/emscripten:$(PATH)

all: dist

serve: dist
	cd dist && python2 -m SimpleHTTPServer 8080

dist: busybox browsix
	rm -rf dist
	mkdir -p dist/fs/bin dist/fs/usr/bin
	\
	cp -r browsix/app/* dist
	cp -r browsix/bower_components dist
	cp -r browsix/node_modules/xterm/dist dist/xterm
	cp browsix/fs/usr/bin/sh browsix/fs/usr/bin/node browsix/fs/usr/bin/ld dist/fs/usr/bin
	\
	cp busybox/busybox_unstripped.js dist/fs/usr/bin/busybox
	cp browsix/fs/bin/sh dist/fs/bin/sh
	cp -r browsix/fs/boot dist/fs
	\
	for i in $$(node dist/fs/usr/bin/busybox --list) ; \
	do \
		echo '#!/bin/sh' > dist/fs/usr/bin/$$i ; \
		echo /usr/bin/busybox $$i '$$@' >> dist/fs/usr/bin/$$i ; \
	done
	\
	browsix/xhrfs-index dist/fs > dist/fs/index.json

busybox:
	emmake $(MAKE) -C busybox CROSS_COMPILE= CC=emcc SKIP_STRIP=y

browsix:
	cd browsix && \
	npm install && \
	./node_modules/.bin/bower install && \
	./node_modules/.bin/gulp app:build app:styles app:elements app:images

clean:
	$(MAKE) -C busybox clean
	$(MAKE) -C browsix clean
	rm -rf dist

.PHONY: all dist serve busybox browsix
