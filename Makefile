PWD := $(shell pwd)
UID := $(shell id -u)
GID := $(shell id -g)

up:
	make composer-install
	docker compose up --build

down:
	docker compose down

composer-install:
	docker run --rm -u $(UID):$(GID) -v $(PWD):/app composer install --ignore-platform-reqs

protoc:
	docker compose exec -u $(UID):$(GID) app /bin/bash -c "protoc \
		--plugin=/opt/protoc-gen-php-grpc \
    	--php_out=./generated \
    	--php-grpc_out=./generated \
    	proto/helloworld.proto"