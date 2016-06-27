FROM rhee/unpam-centos-6
MAINTAINER shr386.docker@outlook.com

RUN yum update -y -q ; yum -y -q install libevent libpcre libssh

###ADD https://github.com/Yelp/dumb-init/releases/download/v1.0.1/dumb-init_1.0.1_amd64 /dumb-init
COPY dumb-init_1.0.1_amd64 /dumb-init
RUN chmod +x /dumb-init

#ADD out/_opt-proxy.tar.gz /

RUN mkdir -p /opt/proxy /opt/proxy/share
COPY tmp/opt/proxy/bin /opt/proxy
COPY tmp/opt/proxy/etc /opt/proxy
COPY tmp/opt/proxy/sbin /opt/proxy
COPY tmp/opt/proxy/share/tor /opt/proxy/share

COPY start.sh /

RUN mkdir -p /opt/proxy/bin
COPY ratproxy-log-summary.sh /opt/proxy/bin

RUN mkdir -p /opt/proxy/etc/privoxy
COPY adblock.action /opt/proxy/etc/privoxy

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
