#!/bin/sh

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

nohup sh -c 'while :; do /opt/proxy/bin/tor -f /opt/proxy/etc/tor/torrc ; sleep 5 ; done' &

sleep 30





echo "Start privoxy ..." 1>&2

mkdir -p /opt/proxy/etc/privoxy
cat <<EOF > /opt/proxy/etc/privoxy/config
user-manual /usr/share/doc/privoxy/user-manual
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
forward                 /                       127.0.0.1:8123
forward                 .local                  .
forward                 10.*.*.*/               .
forward                 127.*.*.*/              .
forward                 172.*.*.*/              .
forward                 192.168.*.*/            .
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
diskCacheRoot=/opt/proxy/var/log/polipo/cache
localDocumentRoot = ""
dnsQueryIPv6 = no
relaxTransparency = maybe
logSyslog = false
logLevel = 3855
tunnelAllowedPorts = 1-65535
EOF

nohup sh -c 'while :; do /opt/proxy/bin/polipo -c /opt/proxy/etc/polipo/config ; sleep 5 ; done' &






echo "Start ratproxy ..." 1>&2

#nohup sh -c 'while :; do /opt/proxy/bin/ratproxy -p 5555 -v /opt/proxy/var/log/ratproxy -w /opt/proxy/var/log/ratproxy/log.txt -r -lfscm | /opt/proxy/bin/tail-decode.sh ; sleep 5; done' &
nohup sh -c 'while :; do /opt/proxy/bin/ratproxy -p 5555 -v /opt/proxy/var/log/ratproxy -r -lfscm | /opt/proxy/bin/ratproxy-log-summary.sh ; sleep 5 ; done' &

tail -F /--nothing--
