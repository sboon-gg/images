REPOSITORY := prbf2
UPDATE_IMAGE := $(REPOSITORY)/update
SERVER_IMAGE := $(REPOSITORY)/server
PROXY_IMAGE := $(REPOSITORY)/proxy
MURMUR_IMAGE := $(REPOSITORY)/murmur
TAG := latest

build-update:
	docker buildx build . -f update.Dockerfile -t $(UPDATE_IMAGE):$(TAG)

run-update:
	docker run -e SERVER_IP="$(SERVER_IP)" -e SERVER_PORT=$(SERVER_PORT) -e LICENSE="$(LICENSE)" --mount src=./application,type=bind,target=/pr $(UPDATE_IMAGE):$(TAG)

update: build-update run-update

build-server:
	docker buildx build . -f server.Dockerfile -t $(SERVER_IMAGE):$(TAG) --target game

build-server-w-svctl:
	docker buildx build . -f server.Dockerfile -t $(SERVER_IMAGE):$(TAG)

build-proxy:
	docker buildx build . -f proxy.Dockerfile -t $(PROXY_IMAGE):$(TAG)

build-murmur:
	docker buildx build . -f murmur.Dockerfile -t $(MURMUR_IMAGE):$(TAG)
