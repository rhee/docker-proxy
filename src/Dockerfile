FROM rhee/unpam-centos-6
MAINTAINER shr386.docker@outlook.com

RUN yum update -y -q && \
    yum -y -q install gcc gcc-c++ make curl wget tar autoconf automake libtool texinfo \
	libevent-devel pcre-devel libssh-devel zlib-devel openssl-devel

COPY ./ /src/

RUN cd /src/polipo-1.1.1 && \
    make PREFIX=/opt/proxy \
         LOCAL_ROOT=/opt/proxy/share/polipo/www \
         DISK_CACHE_ROOT=/opt/proxy/var/log/polipo/cache \
         all install
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
RUN cd /src/tor-0.2.8.9 && \
    autoreconf && \
    sh configure --prefix=/opt/proxy --disable-asciidoc && \
    make && \
    make install
RUN cd /src/ratproxy-1.58/ratproxy && \
    make && \
    install -s ratproxy /opt/proxy/bin && \
    install ../run-ratproxy.sh /opt/proxy/bin && \
    install ../tail-decode.sh /opt/proxy/bin && \
    install ratproxy-report.sh /opt/proxy/bin
RUN cp /src/privoxy-config/* /opt/proxy/etc/privoxy/
