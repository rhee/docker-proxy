#!/usr/bin/make

export CONTAINER=proxy
export IMAGE=rhee/proxy
export PORTS="8118 8123 9050 5555"

build:
	docker build -t $$IMAGE .

#--net=host
#-u $$(id -u):$$(id -g)
#-p 8118:8118
#-p 8123:8123
#-p 9050:9050
#-p 5555:5555

run:	nat
	-docker run --name=$$CONTAINER \
  --restart=unless-stopped \
  --net=host \
  -v /tmp/proxy:/opt/proxy/var \
  -d \
  $$IMAGE

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

.PHONY:	build run rm logs bash
