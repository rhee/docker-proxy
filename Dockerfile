fFROM centos:7
MAINTAINER shr386.docker@outlook.com

RUN yum update -y -q ; yum -y -q install libevent libpcre libssh

#ADD https://github.com/Yelp/dumb-init/releases/download/v1.0.1/dumb-init_1.0.1_amd64.deb /
#RUN dpkg -i dumb-init_1.0.1_amd64.deb

ADD https://github.com/Yelp/dumb-init/releases/download/v1.0.1/dumb-init_1.0.1_amd64 /usr/local/bin/dumb-init
RUN chmod +x /usr/local/bin/dumb-init

ADD opt-proxy-20160421.tar.gz /
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

#ENTRYPOINT [ "/bin/sh" ]
#CMD [ "/start.sh" ]

CMD [ "/usr/local/bin/dumb-init", "/start.sh" ]
