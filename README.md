# PRBF2 Dockerfiles

With these Dockerfiles you can build:
- [PRBF2 server](#PRBF2)
- [Murmur server](#Murmur)
- [MS Proxy](#Proxy)

Additionally there is a Dockerfile (and a script) for updating server in any place.

You can build the images by manually writing docker commands or by using `make`.

If using the later, you can specify repository, image name, and version tag. Refer to `Makefile`.

TODO: describe how to run servers and mount configs

## PRBF2
File: `server.Dockerfile`

This requires PR server files to be placed in `application` directory.

To build an image run:
```sh
$ make build-server
```

Dockerfile has operations to install `svctl` (custom script for rendering).
It is the last stage of build, hence `--target game` specified in `Makefile`.

To build an image with svctl support run:
```sh
$ make build-server-w-svctl
```

### Update
File: `update.Dockerfile`, `scripts/update.sh`

This builds without dependencies and uses a script to update PRBF2 server files.

#### Build
```sh
$ make build-update
```

#### Running
`update.sh` takes two arguments:
- `PR_DIR`: path to server files (required)
- `LICENSE_FILE`: path to license file (optional)

Additionally it reads environment variables:
- `SERVER_IP`
- `SERVER_PORT`
- `LICENSE`: license key

If `SERVER_IP` and `SERVER_PORT` are set then they will be put in `mods/pr/settings/serversettings.con`.
Otherwise existing file will be used.

If `LICENSE_FILE` or `LICENSE` is provided, it will be placed or overwrite existing license.

The `make` way assumes server files are located in `application` directory.
```sh
# Accepts same env vars as update script.
$ SERVER_IP=... SERVER_PORT=... LICENSE=... make run-update
```

## Murmur
File: `murmur.Dockerfile`

This also requires PR server files in `application` directory.

To build an image run:
```sh
$ make build-murmur
```

## Proxy
File: `proxy.Dockerfile`

There is no requirement, source files are downloaded.

To build an image run:
```sh
$ make build-proxy
```

To build a different version of proxy run (specify build argument `PROXY_VER`):
```sh
$ docker buildx build . -f murmur.Dockerfile -t prbf2/proxy:latest --build-arg="PROXY_VER=<proxy_ver>"
```
