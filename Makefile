#!/usr/bin/make

build:	.FORCE
	docker build -t rhee/proxy .

#--net=host

run:	.FORCE
	docker run --name=proxy \
		--restart=unless-stopped \
		-u $$(id -u):$$(id -g) \
		-p 8118:8118 \
		-p 8123:8123 \
		-p 9050:9050 \
		-p 5555:5555 \
		-v /tmp/proxy:/opt/tor/var/log \
		-d \
		rhee/proxy

stop:	.FORCE
	-docker rm -f proxy

.FORCE:
.PHONY:	build
