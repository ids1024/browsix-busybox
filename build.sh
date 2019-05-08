#!/bin/sh

#sudo docker build -t browsix-alpine-build .

sudo docker run \
	--rm \
	-v "$PWD:/browsix-alpine" \
	-w /browsix-alpine \
	-u $(id -u):$(id -g) \
	browsix-alpine-build \
	./build-alpine.sh
