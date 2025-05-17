FROM ghcr.io/roadrunner-server/roadrunner:2025.1.1 AS roadrunner
FROM php:8.3-cli

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y --no-install-recommends \
    cmake \
    git \
    protobuf-compiler \
    unzip \
    wget \
    zip \
    zlib1g-dev \
    libsystemd-dev \
    pkg-config \
    autoconf \
    libtool \
    && docker-php-ext-install sockets \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    && pecl install grpc \
    && docker-php-ext-enable grpc

# Instalar plugins de gRPC para PHP
RUN git clone -b v1.62.0 https://github.com/grpc/grpc && \
    cd grpc && \
    git submodule update --init && \
    mkdir -p cmake/build && \
    cd cmake/build && \
    cmake ../.. && \
    make protoc grpc_php_plugin && \
    cp grpc_php_plugin /usr/local/bin/grpc_php_plugin && \
    chmod +x /usr/local/bin/grpc_php_plugin

# Copiar Roadrunner y Composer
COPY --from=roadrunner /usr/bin/rr /usr/local/bin/rr
COPY --from=composer /usr/bin/composer /usr/bin/composer

# Copiar código fuente
COPY . /code
WORKDIR /code

# Instalar dependencias de Composer
RUN composer install

# Instalar plugins de protoc
RUN ./vendor/bin/rr download-protoc-binary \
    && mv protoc-gen-php-grpc /usr/local/bin/

CMD ["rr", "serve"]