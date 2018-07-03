FROM alpine:3.4
MAINTAINER shr386.docker@outlook.com

RUN apk add --no-cache --virtual .build-deps \
 gcc g++ libc-dev make curl wget tar autoconf automake libtool texinfo \
 libevent-dev pcre-dev libssh-dev zlib-dev openssl-dev && \
apk add --no-cache libevent pcre libssh

RUN mkdir -p /opt/proxy/bin /opt/proxy/etc/privoxy /opt/proxy/sbin /opt/proxy/share/tor

ADD src/polipo-1.1.1.tar.gz /src/
#RUN ls -R /src

RUN cd /src/polipo-1.1.1 && \
make PREFIX=/opt/proxy \
 LOCAL_ROOT=/opt/proxy/share/polipo/www \
 DISK_CACHE_ROOT=/opt/proxy/var/log/polipo/cache \
 all install

RUN mkdir -p /tmp/privoxy-config/
COPY src/privoxy-config/* /tmp/privoxy-config/

ADD src/privoxy-3.0.26-stable-src.tar.gz /src/
COPY src/patch-privoxy-00-gnumakefile /src/privoxy-3.0.26-stable/
RUN (cd /src/privoxy-3.0.26-stable && ls -s -F GNUmakefile.in && patch -p0 < patch-privoxy-00-gnumakefile && chmod +x mkinstalldirs)

#RUN ls -R /src

RUN cd /src/privoxy-3.0.26-stable && \
 autoheader && \
 autoconf && \
 sh configure \
  --prefix=/opt/proxy \
  --sysconfdir=/opt/proxy/etc/privoxy \
  --with-user=nobody \
  --with-group=nobody && \
 make && \
 make install

ADD src/tor-0.2.8.9.tar.gz /src/
#RUN ls -R /src

RUN cd /src/tor-0.2.8.9 && \
 autoreconf && \
 sh configure --prefix=/opt/proxy --disable-asciidoc && \
 make && \
 make install

### RUN cd /src/ratproxy-1.58/ratproxy && \
###  make && \
###  install -s ratproxy /opt/proxy/bin && \
###  install ../run-ratproxy.sh /opt/proxy/bin && \
###  install ../tail-decode.sh /opt/proxy/bin && \
###  install ratproxy-report.sh /opt/proxy/bin

RUN apk del .build-deps && \
 rm -fvr /src

###ADD https://github.com/Yelp/dumb-init/releases/download/v1.0.1/dumb-init_1.0.1_amd64 /dumb-init

COPY dumb-init_1.0.1_amd64 /dumb-init
COPY start.sh /
COPY adblock.action /opt/proxy/etc/privoxy
RUN ( echo '#!/bin/sh'; echo 'tee -a /opt/proxy/etc/privoxy/config' ) > /add-rules.sh
RUN chmod +x /dumb-init /start.sh /add-rules.sh

# polipo 8123, privoxy 8118, ratproxy 5555, tor 9050
EXPOSE 8123
EXPOSE 8118
# EXPOSE 5555
EXPOSE 9050

# log, cache, etc
VOLUME [ "/opt/proxy/var","/opt/proxy/etc" ]

# go to where keyfile.pem placed
ENV PATH=/opt/proxy/bin:$PATH
WORKDIR /opt/proxy/bin

CMD [ "/dumb-init", "/start.sh" ]
