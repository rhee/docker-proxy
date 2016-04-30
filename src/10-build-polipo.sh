:
set -e
make PREFIX=/opt/proxy LOCAL_ROOT=/opt/proxy/share/polipo/www DISK_CACHE_ROOT=/opt/proxy/var/log/polipo/cache all install
