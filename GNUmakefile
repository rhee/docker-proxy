#!/usr/bin/make

build:	.FORCE
	docker build -t rhee/proxy .

#--net=host
#-u $$(id -u):$$(id -g)

run:	.FORCE
	docker run --name=proxy \
		--restart=unless-stopped \
                --net=host \
		-p 8118:8118 \
		-p 8123:8123 \
		-p 9050:9050 \
		-p 5555:5555 \
		-v /tmp/proxy:/opt/proxy/var \
		-d \
		rhee/proxy

stop:	.FORCE
	-docker rm -f proxy

.FORCE:
.PHONY:	build
