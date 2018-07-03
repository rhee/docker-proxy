:
docker run --name proxy -d \
  -p 8123:8123 \
  -p 8118:8118 \
  -p 9050:9050 \
  -v $PWD/var:/opt/proxy/var \
  -v $PWD/etc:/opt/proxy/etc \
  proxy:alpine3.4 \
  "$@"
