:
set -e
#autoheader
#autoconf
autoreconf
sh configure --prefix=/opt/proxy --disable-asciidoc
make
make install
