## nginx

![GitHub tag](https://img.shields.io/github/release/monder/nginx-aci.svg?style=flat-square)
![nginx](https://img.shields.io/badge/nginx-1.11.3-green.svg?style=flat-square)
![openssl](https://img.shields.io/badge/openssl-1.0.2h-green.svg?style=flat-square)
![pcre](https://img.shields.io/badge/pcre-8.39-green.svg?style=flat-square)
![musl](https://img.shields.io/badge/musl-1.1.14-green.svg?style=flat-square)
![zlib](https://img.shields.io/badge/zlib-1.2.8-green.svg?style=flat-square)

The minimalistic `aci` that contains [nginx](http://nginx.org). Nothing else.

The binary is statically compiled with `musl`, `openssl`, `zlib`, `pcre` and has no dependencies.

```
$ file nginx
nginx: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), statically linked, not stripped
```

### rkt-image
Signed `aci` images are available as `monder.cc/nginx:v1.11.3-r0` following the github tags.

```
$ rkt run monder.cc/nginx:v1.11.3-r0
```

### build
For the siplicity of building the `aci` without the need of installing `musl` cc tools 
and `acibuild` everything is could be done in `docker`.

`build-aci-in-docker.sh` script prepares the environment in docker
and launches the build script. Resulting image will be in the current dir.

### configuration
```yaml
  nginx path prefix: "/nginx"
  nginx binary file: "/bin/nginx"
  nginx modules path: "/nginx/modules"
  nginx configuration prefix: "/nginx/conf"
  nginx configuration file: "/nginx/conf/nginx.conf"
  nginx pid file: "/nginx/logs/nginx.pid"
  nginx error log file: "/nginx/logs/error.log"
  nginx http access log file: "/nginx/logs/access.log"
```

