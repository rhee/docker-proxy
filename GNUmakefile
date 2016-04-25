#!/usr/bin/make

export IMAGE:=rhee/proxy
export CONTAINER:=proxy

build:
	docker build -t $$IMAGE .

#--net=host
#-u $$(id -u):$$(id -g)

run:
	docker run --name=$$CONTAINER \
--restart=unless-stopped \
-p 8118:8118 \
-p 8123:8123 \
-p 9050:9050 \
-p 5555:5555 \
-v /tmp/proxy:/opt/proxy/var \
-d \
$$IMAGE
	-@VBoxManage controlvm default natpf1 tcp-8118,tcp,,8118,,8118
	-@VBoxManage controlvm default natpf1 tcp-8123,tcp,,8123,,8123
	-@VBoxManage controlvm default natpf1 tcp-9050,tcp,,9050,,9050
	-@VBoxManage controlvm default natpf1 tcp-5555,tcp,,5555,,5555

rm:
	-docker rm -f $$CONTAINER
	-@VBoxManage controlvm default natpf1 delete tcp-8118
	-@VBoxManage controlvm default natpf1 delete tcp-8123
	-@VBoxManage controlvm default natpf1 delete tcp-9050
	-@VBoxManage controlvm default natpf1 delete tcp-5555

logs:
	docker logs --follow $$CONTAINER

bash:
	docker exec -ti $$CONTAINER bash

.PHONY:	build run rm logs bash
