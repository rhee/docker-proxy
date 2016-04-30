
set -e
autoheader
autoconf
sh configure --prefix=/opt/proxy --disable-asciidoc
make
make install
