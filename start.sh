#!/bin/sh

set -e

for d in run log/tor log/polipo log/polipo/cache log/privoxy log/ratproxy; do
  mkdir -p -m 755 /opt/proxy/var/$d
done




echo "Start tor ..." 1>&2

mkdir -p /opt/proxy/etc/tor
cat <<EOF > /opt/proxy/etc/tor/torrc
SocksPort 9050
ControlPort 9051
SocksListenAddress 0.0.0.0
Log notice stderr
RunAsDaemon 0
ExcludeNodes {kr},{cn}
HashedControlPassword 16:58559D2611103DF26020C6011A00E4A5FA50B16D2B550EB69DD6958744
EOF

nohup sh -c 'while :; do /opt/proxy/sbin/tor -f /opt/proxy/etc/tor/torrc ; sleep 5 ; done' &

sleep 30





echo "Start privoxy ..." 1>&2

mkdir -p /opt/proxy/etc/privoxy
cp /tmp/privoxy-config/* /opt/proxy/etc/privoxy/
cat <<EOF > /opt/proxy/etc/privoxy/config
confdir /opt/proxy/etc/privoxy
actionsfile match-all.action # Actions that are applied to all sites and maybe overruled later on.
actionsfile default.action   # Main actions file
actionsfile user.action      # User customizations
actionsfile adblock.action      # User customizations
debug 1537
listen-address  :8118
toggle  1
enable-remote-toggle  0
enable-remote-http-toggle  0
enable-edit-actions 0
enforce-blocks 0
buffer-limit 4096
forwarded-connect-retries  0
accept-intercepted-requests 0
allow-cgi-request-crunching 0
split-large-forms 0
socket-timeout 300
# NOTE: *LAST* MATCH WINS
#forward                 /                       127.0.0.1:8123
forward-socks5          /                       127.0.0.1:9050 .
forward                 .local                  .
forward                 10.*.*.*/               .
forward                 127.*.*.*/              .
forward                 172.*.*.*/              .
forward                 192.168.*.*/            .
forward                 .google.com             .
forward                 .naver.com              .
forward                 .daum.net               .
forward-socks5          .onion                  127.0.0.1:9050 .
#forward-socks5          some.other.domain       127.0.0.1:9050 .
EOF

nohup sh -c 'while :; do /opt/proxy/sbin/privoxy --no-daemon /opt/proxy/etc/privoxy/config ; sleep 5 ; done' &






echo "Start polipo ..." 1>&2

mkdir -p /opt/proxy/etc/polipo
cat<<EOF > /opt/proxy/etc/polipo/config
proxyAddress = "0.0.0.0"    # IPv4 only
chunkHighMark = 50331648
objectHighMark = 16384
#diskCacheRoot=/opt/proxy/var/log/polipo/cache
diskCacheRoot= ""
localDocumentRoot = ""
dnsQueryIPv6 = no
pmmFirstSize = 16384
pmmSize = 8192
parentProxy = 127.0.0.1:8118
relaxTransparency = maybe
logSyslog = false
logLevel = 3855
tunnelAllowedPorts = 1-65535
EOF

nohup sh -c 'while :; do /opt/proxy/sbin/polipo -c /opt/proxy/etc/polipo/config ; sleep 5 ; done' &



tail -F /--nothing--
