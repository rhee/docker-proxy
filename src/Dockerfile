FROM rhee/unpam-centos-6
MAINTAINER shr386.docker@outlook.com

#ENV PATH=/opt/proxy/bin:/usr/lib64/ccache:$PATH
#ENV CCACHE_DIR=/src/.ccache

RUN yum update -y -q
RUN yum -y -q install gcc gcc-c++ make curl wget tar autoconf automake libtool texinfo
RUN yum -y -q install libevent-devel pcre-devel libssh-devel zlib-devel openssl-devel

COPY ./ /src/

WORKDIR /src/polipo-1.1.1
RUN sh ../10-build-polipo.sh
WORKDIR /src/privoxy-3.0.19-stable
RUN sh ../20-build-privoxy.sh
WORKDIR /src/tor-0.2.7.6
RUN sh ../30-build-tor.sh
WORKDIR /src/ratproxy-1.58/ratproxy
RUN sh ../../40-build-ratproxy.sh
RUN cp /src/privoxy-config/* /opt/proxy/etc/privoxy/

#RUN tar cvzf /out/_opt-proxy.tar.gz -C / opt/proxy/bin opt/proxy/etc opt/proxy/sbin opt/proxy/share/tor
