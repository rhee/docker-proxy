FROM alpine:3.21.3
LABEL maintainer="shr386.docker@outlook.com"

RUN apk add --no-cache --virtual .build-deps build-essential gcc g++ make curl wget tar autoconf automake libtool texinfo \
	libevent-dev pcre-dev libssh-dev zlib-dev openssl-dev

#COPY ./ /src/
ADD privoxy-4.0.0-stable-src.tar.gz /src/
ADD tor-0.4.8.17.tar.gz /src/

# RUN cd /src/polipo-1.1.1 && \
#     make PREFIX=/opt/proxy \
#          LOCAL_ROOT=/opt/proxy/share/polipo/www \
#          DISK_CACHE_ROOT=/opt/proxy/var/log/polipo/cache \
#          all install
RUN cd /src/privoxy-4.0.0-stable && \
    autoheader && \
    autoconf && \
    sh configure \
	--prefix=/opt/proxy \
	--sysconfdir=/opt/proxy/etc/privoxy \
	--with-user=nobody \
	--with-group=nobody && \
    make && \
    make install
RUN cd /src/tor-0.4.8.17 && \
    autoreconf && \
    sh configure --prefix=/opt/proxy --disable-asciidoc && \
    make && \
    make install
# RUN cd /src/ratproxy-1.58/ratproxy && \
#     make && \
#     install -s ratproxy /opt/proxy/bin && \
#     install ../run-ratproxy.sh /opt/proxy/bin && \
#     install ../tail-decode.sh /opt/proxy/bin && \
#     install ratproxy-report.sh /opt/proxy/bin
#RUN cp privoxy-config/* /opt/proxy/etc/privoxy/
COPY privoxy-config/ /opt/proxy/etc/privoxy/

RUN apk del .build-deps && rm -rf /var/cache/apk/*

