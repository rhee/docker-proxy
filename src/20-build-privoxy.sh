:
set -e
autoheader
autoconf
sh configure --prefix=/opt/proxy --sysconfdir=/opt/proxy/etc/privoxy --with-user=nobody --with-group=nobody
make
make install
