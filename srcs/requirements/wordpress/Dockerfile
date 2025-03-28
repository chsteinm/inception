FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y php-fpm php-mysql curl unzip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*\
    && curl -O https://wordpress.org/latest.tar.gz \
    && tar -xzvf latest.tar.gz \
    && rm latest.tar.gz \
    && mkdir -p /var/www/html && mv wordpress /var/www/html \
    && chown -R www-data:www-data /var/www/html \
    && mkdir -p /run/php && chown www-data:www-data /run/php

EXPOSE 9000

CMD ["php-fpm7.4", "--nodaemonize"]