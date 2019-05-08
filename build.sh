#!/bin/sh

IMAGE=ids1024/browsix-alpine-build

sudo docker pull $IMAGE

sudo docker run \
	--rm \
	-v "$PWD:/browsix-alpine" \
	-w /browsix-alpine \
	-u $(id -u):$(id -g) \
	$IMAGE \
	./build-alpine.sh
