PWD := $(shell pwd)
UID := $(shell id -u)
GID := $(shell id -g)

up:
	make composer-install
	docker compose up

down:
	docker compose down

composer-install:
	docker run --rm -u $(UID):$(GID) -v $(PWD):/app composer install --ignore-platform-reqs

protoc:
	docker compose exec -u $(UID):$(GID) app /bin/bash -c "protoc \
		--plugin=protoc-gen-grpc=/usr/local/bin/grpc_php_plugin \
		--plugin=protoc-gen-php-grpc=/usr/local/bin/protoc-gen-php-grpc \
    	--php_out=/code/generated \
	   	--php-grpc_out=/code/generated \
    	--grpc_out=/code/generated \
    	$$(find proto -name '*.proto')"

install-grpc-client-cli:
	docker compose exec app /bin/bash -c "curl -L https://github.com/vadimi/grpc-client-cli/releases/download/v1.22.3/grpc-client-cli_linux_x86_64.tar.gz | tar -C /usr/local/bin -xz"

use-grpc-client-cli:
	docker compose exec app /bin/bash -c "grpc-client-cli --proto proto/helloworld.proto 127.0.0.1:9001"

use-grpc-client:
	docker compose exec app /bin/bash -c "php grpc-client.php"