FROM alpine:3.4 as builder
MAINTAINER shr386.docker@outlook.com

RUN apk add --no-cache --virtual .build-deps \
 gcc g++ libc-dev make curl wget tar autoconf automake libtool texinfo \
 libevent-dev pcre-dev libssh-dev zlib-dev openssl-dev && \
 apk add --no-cache libevent pcre libssh squid

RUN mkdir -p /opt/proxy/bin /opt/proxy/etc/privoxy /opt/proxy/sbin /opt/proxy/share/tor

### ADD src/polipo-1.1.1.tar.gz /src/
### #RUN ls -R /src
### RUN cd /src/polipo-1.1.1 && \
###  make PREFIX=/opt/proxy \
###   LOCAL_ROOT=/opt/proxy/share/polipo/www \
###   DISK_CACHE_ROOT=/opt/proxy/var/log/polipo/cache \
###   all install

##ADD src/privoxy-3.0.26-stable-src.tar.gz /src/privoxy
ADD https://www.privoxy.org/sf-download-mirror/Sources/3.0.28%20%28stable%29/privoxy-3.0.28-stable-src.tar.gz /src/
RUN ls -l /src && tar -x -f /src/privoxy-3.0.28-stable-src.tar.gz -C /src && ls -l src
COPY src/patch-privoxy-00-gnumakefile /src/privoxy-3.0.28-stable/
RUN cd /src/privoxy-3.0.28-stable && \
 patch -p0 < patch-privoxy-00-gnumakefile && \
 chmod +x mkinstalldirs && \
 autoheader && \
 autoconf && \
 sh configure \
  --prefix=/opt/proxy \
  --sysconfdir=/opt/proxy/etc/privoxy \
  --with-user=nobody \
  --with-group=nobody && \
 make && \
 make install

##ADD src/tor-0.2.8.9.tar.gz /src/tor
ADD https://dist.torproject.org/tor-0.4.3.6.tar.gz /src/
RUN ls -l /src && tar -x -f /src/tor-0.4.3.6.tar.gz -C /src && ls -l src
RUN cd /src/tor-0.4.3.6 && \
 autoreconf && \
 sh configure --prefix=/opt/proxy --disable-asciidoc && \
 make && \
 make install

RUN apk del .build-deps && \
 rm -fvr /src

##############################################################
##############################################################
##############################################################



FROM alpine:3.4
MAINTAINER shr386.docker@outlook.com

RUN apk add --no-cache libevent pcre libssh squid

COPY --from=builder /opt/proxy /opt/proxy

### ADD https://github.com/Yelp/dumb-init/releases/download/v1.0.1/dumb-init_1.0.1_amd64 /dumb-init
COPY dumb-init_1.0.1_amd64 /dumb-init
RUN chmod +x /dumb-init

RUN ( echo '#!/bin/sh'; echo 'tee -a /opt/proxy/etc/privoxy/config' ) > /add-rules.sh
RUN chmod +x /add-rules.sh

RUN mkdir -p /tmp/privoxy-config/
COPY src/privoxy-config/* /tmp/privoxy-config/
COPY adblock.action /tmp/privoxy-config/

#COPY src/squid.conf /src/squid.conf

COPY start.sh /start.sh
RUN chmod +x /start.sh

# polipo 3128, privoxy 8118, tor 9050
EXPOSE 3128
EXPOSE 8118
# EXPOSE 5555
EXPOSE 9050

# log, cache, etc
VOLUME [ "/opt/proxy/var","/opt/proxy/etc" ]

# go to where keyfile.pem placed
ENV PATH=/opt/proxy/bin:$PATH
WORKDIR /opt/proxy/bin

CMD [ "/dumb-init", "/start.sh" ]

