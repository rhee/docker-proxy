#!/bin/sh

# other options:
#-lextifscgjm -d safe4kid.co.kr "$@"
#-lfscm -d safe4kid.co.kr "$@"
#-lextifscgjm -d www.safe4kid.co.kr "$@"
#-lextifscgjm "$@"
#-lfscm "$@"

#cat <<'EOF'
#HOW TO MONITOR: tail -F traces/log.txt | perl -p -e 's/\&#x([0-9a-f]{2});/chr(hex($1));/eg' &
#EOF

LOGDIR=/opt/proxy/var/log/ratproxy
mkdir -p "$LOGDIR"

exec ratproxy -p 5555 -v "$LOGDIR" -w "$LOGDIR"/log.txt -r -lfscm "$@"
