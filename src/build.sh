#!/bin/sh

( cd polipo-1.0.4.1 ; sh ../10-build-polipo.sh )

( cd privoxy-3.0.19-stable ; sh ../20-build-privoxy.sh )

( cd tor-0.2.2.35 ; sh ../30-build-tor.sh )

( cd ratproxy-1.58/ratproxy ; sh ../../40-build-ratproxy.sh )

tar cvzf /out/__opt-proxy__.tar.gz -C / opt/proxy/bin opt/proxy/etc opt/proxy/sbin opt/proxy/share/tor
