#!/usr/bin/make

MAKEFILE:=$(lastword $(MAKEFILE_LIST))

export CONTAINER=proxy
export IMAGE=rhee/proxy
export PORTS="8118 8123 9050 5555"

build:
	$(MAKE) -f $(MAKEFILE) _build 2>&1 | tee -a build.log

_build:
	mkdir -p out opt
	docker build -t $$IMAGE-builder src
	docker run --name=$$CONTAINER-builder --rm \
		-u $$(id -u):$$(id -g) \
		-v $$PWD/out:/out \
		-v $$PWD/opt:/opt \
		-v $$PWD/src:/src \
		$$IMAGE-builder
	docker build -t $$IMAGE .

#--net=host
#-u $$(id -u):$$(id -g) \

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
	    $$IMAGE

unrun:
	docker rm -f $$CONTAINER

rm:	unnat
	-docker rm -f $$CONTAINER

nat:
	-if [ ! -z "$$DOCKER_MACHINE_NAME" ]; \
then \
  for port in $$PORTS; do \
    VBoxManage controlvm default natpf1 tcp-$$port,tcp,,$$port,,$$port; \
  done; \
fi

unnat:
	-if [ ! -z "$$DOCKER_MACHINE_NAME" ]; \
then \
  for port in $$PORTS; do \
    VBoxManage controlvm default natpf1 delete tcp-$$port; \
  done; \
fi

logs:
	docker logs --follow $$CONTAINER

bash:
	docker exec -ti $$CONTAINER bash

.PHONY:	build _build run rm logs bash unrun rerun
