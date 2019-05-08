#!/bin/sh

set -e

IMAGE=ids1024/browsix-build

sudo docker pull $IMAGE

sudo docker run \
	--rm \
	-it \
	-p 0.0.0.0:8080:8080/tcp \
	-v "$PWD:/browsix-alpine" \
	-w /browsix-alpine \
	-u $(id -u):$(id -g) \
	$IMAGE \
	./build-alpine.sh
