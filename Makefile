IMAGE := ids1024/browsix-build
DOCKER_RUN := sudo docker run \
	--rm \
	-it \
	-v "$(PWD):/browsix-alpine" \
	-u $(shell id -u):$(shell id -g)
export PATH := $(PWD)/emscripten:$(PATH)
export HOME := $(PWD)

serve: dist
	$(DOCKER_RUN) \
		-p 0.0.0.0:8080:8080/tcp \
		-w /browsix-alpine/dist \
		$(IMAGE) \
		python2 -m SimpleHTTPServer 8080

dist: busybox browsix
	$(DOCKER_RUN) \
		-w /browsix-alpine \
		$(IMAGE) \
		./dist.sh

busybox:
	$(DOCKER_RUN) \
		-w /browsix-alpine \
		$(IMAGE) \
		./build-busybox.sh

browsix:
	$(DOCKER_RUN) \
		-w /browsix-alpine \
		$(IMAGE) \
		./build-browsix.sh

clean:
	cd busybox && make clean
	cd browsix && make clean
	rm -rf dist

.PHONY: dist serve busybox browsix
