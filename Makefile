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