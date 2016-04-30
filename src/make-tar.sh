#!/bin/sh
STAMP=$(date +%Y%m%d)
tar cvzf /opt-proxy-$STAMP.tar.gz -C / opt/proxy/bin opt/proxy/etc opt/proxy/sbin opt/proxy/share/tor
tar cvzf /opt-proxy-src-$STAMP.tar.gz -C / opt/proxy/src
