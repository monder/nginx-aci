#!/bin/sh
BUILDER=`cat ./build-aci.sh`

docker run -it -v "$PWD":/release alpine:3.4 /bin/sh -c "
  apk add --no-cache build-base curl perl go git bash;
  mkdir /root/go
  export GOPATH=/root/go
  go get github.com/appc/acbuild
  cd /root/go/src/github.com/appc/acbuild
  ./build
  cp ./bin/acbuild /usr/bin/    
  
  ${BUILDER}

  cp -f nginx-v\${NGINX_VERSION}-r\${RELEASE}-linux-amd64.aci /release/
"
