#!/usr/bin/make

MAKEFILE:=$(lastword $(MAKEFILE_LIST))

export CONTAINER=proxy
export OWNER=rhee
export IMAGE=proxy
export PORTS="8118 8123 9050 5555"

build:	.FORCE
	docker build -t $$IMAGE-builder src
	-docker rm $$CONTAINER-builder
	docker create --name=$$CONTAINER-builder $$IMAGE-builder
	mkdir -p tmp
	docker cp $$CONTAINER-builder:/opt tmp
	docker build -t $$OWNER/$$IMAGE .

rerun:	unrun run

run:	nat
	mkdir -p /tmp/$$(id -u)
	-docker run --name=$$CONTAINER \
	    --restart=unless-stopped \
	    -p 8118:8118 \
	    -p 8123:8123 \
	    -p 9050:9050 \
	    -p 5555:5555 \
	    -v /tmp/$$(id -u)/proxy:/opt/proxy/var \
	    -d \
	    $$OWNER/$$IMAGE

unrun:;	docker rm -f $$CONTAINER

rm:	unnat
	-docker rm -f $$CONTAINER

nat:;	-if [ ! -z "$$DOCKER_MACHINE_NAME" ]; \
then \
  for port in $$PORTS; do \
    VBoxManage controlvm default natpf1 tcp-$$port,tcp,,$$port,,$$port; \
  done; \
fi

unnat:;	-if [ ! -z "$$DOCKER_MACHINE_NAME" ]; \
then \
  for port in $$PORTS; do \
    VBoxManage controlvm default natpf1 delete tcp-$$port; \
  done; \
fi

logs:;	docker logs --tail=50 --follow $$CONTAINER

bash:;	docker exec -ti $$CONTAINER bash

.FORCE:
.PHONY:	.FORCE build _build run rm logs bash unrun rerun
