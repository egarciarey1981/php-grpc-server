FROM ghcr.io/roadrunner-server/roadrunner:2025.1.1 AS roadrunner
FROM php:8.3-cli

COPY --from=roadrunner /usr/bin/rr /usr/local/bin/rr

RUN docker-php-ext-install sockets

RUN apt-get update && apt-get install -y \
    protobuf-compiler \
    zip

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
COPY . /code
WORKDIR /code
RUN composer install

RUN ./vendor/bin/rr download-protoc-binary && mv protoc-gen-php-grpc /opt/

CMD rr serve -c .rr.yaml