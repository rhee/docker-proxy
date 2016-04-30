:
set -e
make
install -s ratproxy /opt/proxy/bin
install ../run-ratproxy.sh /opt/proxy/bin
install ../tail-decode.sh /opt/proxy/bin
install ratproxy-report.sh /opt/proxy/bin
