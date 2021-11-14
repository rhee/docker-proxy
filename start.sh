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

nohup /opt/proxy/bin/tor -f /opt/proxy/etc/tor/torrc &

#sleep 30





echo "Start privoxy ..." 1>&2

mkdir -p /opt/proxy/etc/privoxy
#cp /tmp/privoxy-config/* /opt/proxy/etc/privoxy/
cat <<EOF > /opt/proxy/etc/privoxy/config
user-manual /opt/proxy/share/doc/privoxy/user-manual
confdir /opt/proxy/etc/privoxy
#actionsfile match-all.action # Actions that are applied to all sites and maybe overruled later on.
#actionsfile default.action   # Main actions file
#actionsfile user.action      # User customizations
#actionsfile adblock.action      # User customizations
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
#forward                 /                       127.0.0.1:3128
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
EOF

nohup /opt/proxy/sbin/privoxy --no-daemon /opt/proxy/etc/privoxy/config &






### echo "Start polipo ..." 1>&2
### 
### mkdir -p /opt/proxy/etc/polipo
### cat<<EOF > /opt/proxy/etc/polipo/config
### proxyAddress = "0.0.0.0"    # IPv4 only
### proxyPort = 3128
### chunkHighMark = 50331648
### objectHighMark = 16384
### #diskCacheRoot=/opt/proxy/var/log/polipo/cache
### diskCacheRoot= ""
### localDocumentRoot = ""
### dnsQueryIPv6 = no
### pmmFirstSize = 16384
### pmmSize = 8192
### parentProxy = 127.0.0.1:8118
### relaxTransparency = maybe
### logSyslog = false
### logLevel = 3855
### tunnelAllowedPorts = 1-65535
### EOF

### nohup /opt/proxy/bin/polipo -c /opt/proxy/etc/polipo/config &




echo "Start squid ..." 1>&2

mkdir -p /opt/proxy/etc/squid
cat<<EOF > /opt/proxy/etc/squid/squid.conf
acl all src all
acl manager proto cache_object
acl localhost src 127.0.0.1/32
acl localnet src 10.0.0.0/8	# RFC1918 possible internal network
acl localnet src 172.16.0.0/12	# RFC1918 possible internal network
acl localnet src 192.168.0.0/16	# RFC1918 possible internal network
acl SSL_ports port 443		# https
acl SSL_ports port 563		# snews
acl SSL_ports port 873		# rsync
acl Safe_ports port 80		# http
acl Safe_ports port 21		# ftp
acl Safe_ports port 443		# https
acl Safe_ports port 70		# gopher
acl Safe_ports port 210		# wais
acl Safe_ports port 1025-65535	# unregistered ports
acl Safe_ports port 280		# http-mgmt
acl Safe_ports port 488		# gss-http
acl Safe_ports port 591		# filemaker
acl Safe_ports port 777		# multiling http
acl Safe_ports port 631		# cups
acl Safe_ports port 873		# rsync
acl Safe_ports port 901		# SWAT
acl purge method PURGE
acl CONNECT method CONNECT
http_access allow manager localhost
http_access deny manager
http_access allow purge localhost
http_access deny purge
http_access deny !Safe_ports
http_access deny CONNECT !SSL_ports
http_access allow localhost
http_access allow localnet
http_access deny all
icp_access allow localhost
icp_access allow localnet
icp_access deny all
http_port 3128
access_log /dev/null squid
refresh_pattern ^ftp:		1440	20%	10080
refresh_pattern ^gopher:	1440	0%	1440
refresh_pattern -i (/cgi-bin/|\?) 0	0%	0
refresh_pattern (Release|Packages(.gz)*)$	0	20%	2880
refresh_pattern .		0	20%	4320
acl shoutcast rep_header X-HTTP09-First-Line ^ICY.[0-9]
acl apache rep_header Server ^Apache
coredump_dir /var/spool/squid
cache_peer 127.0.0.1 parent 8118 0 no-query no-digest
never_direct allow all
EOF

## obsolete
#upgrade_http0.9 deny shoutcast
#broken_vary_encoding allow apache
#extension_methods REPORT MERGE MKACTIVITY CHECKOUT
#hierarchy_stoplist cgi-bin ?
#acl to_localhost dst 127.0.0.0/8 0.0.0.0/32
#hosts_file /etc/hosts

nohup bash -c 'while :; do /usr/sbin/squid -N -f /opt/proxy/etc/squid/squid.conf -a 3128 -u 3130; sleep 30; done' &

tail -F /--nothing--
