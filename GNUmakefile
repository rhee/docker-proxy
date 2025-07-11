#
build:	.FORCE
	podman build --platform linux/amd64 -t proxy:alpine3.21-$(shell date +%Y%m%d) .
.FORCE:
.PHONY: .FORCE build
