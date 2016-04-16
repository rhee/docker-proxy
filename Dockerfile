FROM centos:7
MAINTAINER shr386.docker@outlook.com

# polipo
EXPOSE 8128
# privoxy
EXPOSE 8118
# ratproxy
EXPOSE 5555
# tor
EXPOSE 9050

# log, cache, etc
VOLUME [ "/opt/proxy/var","/opt/proxy/etc" ]

ADD opt-proxy-20160416.tar.gz /
ADD start.sh /

RUN yum -y install libevent libpcre libssh

ENV PATH=/opt/proxy/bin:$PATH

# go to where keyfile.pem placed
WORKDIR /opt/proxy/bin

ENTRYPOINT [ "/bin/sh" ]
CMD [ "/start.sh" ]
