#!/bin/sh

for d in run log/tor log/polipo log/polipo/cache log/privoxy log/ratproxy; do
  mkdir -p -m 755 /opt/proxy/var/$d
done

/opt/proxy/bin/tor -f /opt/proxy/etc/tor/torrc &
/opt/proxy/sbin/privoxy /opt/proxy/etc/privoxy/config &
/opt/proxy/bin/polipo -c /opt/proxy/etc/polipo/config &
/opt/proxy/bin/ratproxy -p 5555 -v /opt/proxy/var/log/ratproxy -w /opt/proxy/var/log/ratproxy/log.txt -r -lfscm &

exec tail -F \
/opt/proxy/var/log/polipo/polipo.log \
/opt/proxy/var/log/tor/tor.log \
/opt/proxy/var/log/privoxy/logfile \
/opt/proxy/var/log/ratproxy/log.txt 1>&2
