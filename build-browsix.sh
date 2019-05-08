#!/bin/sh

set -e

export HOME=$PWD

cd browsix
	npm install
	./node_modules/.bin/bower install
	./node_modules/.bin/gulp app:build app:styles app:elements app:images
cd ..
