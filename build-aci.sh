#!/bin/sh

RELEASE=0

NGINX_VERSION=1.11.3
OPENSSL_VERSION=1.0.2h
PCRE_VERSION=8.39
ZLIB_VERSION=1.2.8

CONFIG="\
  --with-cc-opt='-static' \
  --with-ld-opt='-static' \
  --prefix=/nginx \
  --with-http_ssl_module \
  --with-http_realip_module \
  --with-http_sub_module \
  --with-http_gunzip_module \
  --with-http_stub_status_module \
  --with-threads \
  --with-stream \
  --with-stream_ssl_module \
  --with-http_v2_module \
  --with-ipv6 \
  --with-pcre-jit \
  --with-pcre=../pcre-$PCRE_VERSION \
  --with-openssl=../openssl-$OPENSSL_VERSION \
  --with-zlib=../zlib-$ZLIB_VERSION \
"

curl -fSL http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz -o nginx.tar.gz
curl -fSL https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz -o openssl.tar.gz
curl -fSL ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-$PCRE_VERSION.tar.gz -o pcre.tar.gz
curl -fSL http://zlib.net/zlib-$ZLIB_VERSION.tar.gz -o zlib.tar.gz

tar -zxf nginx.tar.gz && rm nginx.tar.gz
tar -zxf openssl.tar.gz && rm openssl.tar.gz
tar -zxf pcre.tar.gz && rm pcre.tar.gz
tar -zxf zlib.tar.gz && rm zlib.tar.gz

cd nginx-$NGINX_VERSION
./configure $CONFIG
make -j4

ACBUILD='acbuild --no-history'

$ACBUILD begin
$ACBUILD set-name monder.cc/nginx
$ACBUILD copy objs/nginx /bin/nginx
$ACBUILD copy-to-dir conf /nginx/
$ACBUILD copy /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
mkdir .acbuild/currentaci/rootfs/nginx/logs/
echo 'nobody:x:65534:65534:nobody:/:/dev/null' > .acbuild/currentaci/rootfs/etc/passwd
echo 'nobody:x:65534:' > .acbuild/currentaci/rootfs/etc/group
$ACBUILD set-exec -- /bin/nginx -g "daemon off;"
$ACBUILD label add version v$NGINX_VERSION-r${RELEASE}
$ACBUILD label add arch amd64
$ACBUILD label add os linux    
echo '{ "set": ["CAP_NET_BIND_SERVICE", "CAP_CHOWN", "CAP_SETGID", "CAP_SETUID"] }' | $ACBUILD isolator add os/linux/capabilities-retain-set - 
$ACBUILD annotation add authors "Aleksejs Sinicins <monder@monder.cc>"
$ACBUILD write nginx-v${NGINX_VERSION}-r${RELEASE}-linux-amd64.aci --overwrite  
$ACBUILD end

