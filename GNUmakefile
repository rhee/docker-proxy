#
build:	.FORCE
	podman build --network=host --platform linux/amd64 -t proxy:alpine3.21-$(shell date +%Y%m%d) .
.FORCE:
.PHONY: .FORCE build
