FROM centos:7
MAINTAINER shr386.docker@outlook.com

RUN yum update -y -q ; yum -y -q install libevent libpcre libssh

###ADD https://github.com/Yelp/dumb-init/releases/download/v1.0.1/dumb-init_1.0.1_amd64 /dumb-init
COPY dumb-init_1.0.1_amd64 /dumb-init
RUN chmod +x /dumb-init

ADD out/__opt-proxy__.tar.gz /
COPY start.sh /

ENV PATH=/opt/proxy/bin:$PATH

# polipo 8128, privoxy 8118, ratproxy 5555, tor 9050
EXPOSE 8128
EXPOSE 8118
EXPOSE 5555
EXPOSE 9050

# log, cache, etc
VOLUME [ "/opt/proxy/var","/opt/proxy/etc" ]

# go to where keyfile.pem placed
WORKDIR /opt/proxy/bin

CMD [ "/dumb-init", "/start.sh" ]
