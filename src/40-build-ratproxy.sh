:
set -e
make
install -s ratproxy /opt/proxy/bin
install run-ratproxy.sh ratproxy-report.sh tail-decode.sh /opt/proxy/bin

