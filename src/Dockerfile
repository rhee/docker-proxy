FROM centos:7
MAINTAINER shr386.docker@outlook.com

ENV PATH=/opt/proxy/bin:/usr/lib64/ccache:$PATH
ENV CCACHE_DIR=/opt/proxy/src/.ccache

RUN yum update -y -q
RUN yum -y -q install gcc gcc-c++ make curl wget tar autoconf automake texinfo ccache
RUN yum -y -q install libevent-devel pcre-devel libssh-devel

### 00-prerequeisites.sh
RUN yum install -y -q libevent-devel pcre-devel libssh-devel gcc gcc-c++ make autoconfig libtool zlib-devel openssl-devel

WORKDIR /src

CMD /bin/bash /src/build.sh
