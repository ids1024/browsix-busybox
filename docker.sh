#!/bin/sh

IMAGE=browsix-busybox-build

cd docker
	sudo docker build . -t $IMAGE 
cd ..

sudo docker run \
	--rm \
	-it \
	-v "$PWD:/browsix-alpine:Z" \
	-u $(id -u):$(id -g) \
	-w /browsix-alpine \
	-p 0.0.0.0:8080:8080/tcp \
	-e HOME=/browsix-alpine \
	-e PWD=/browsix-alpine \
	$IMAGE \
	$@
