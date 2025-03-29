FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y \
    php7.4 php7.4-fpm php7.4-mysql curl wget tar unzip \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /run/php && chown www-data:www-data /run/php

WORKDIR /var/www/html
RUN wget https://wordpress.org/latest.tar.gz \
    && tar -xzvf latest.tar.gz --strip-components=1 \
    && rm latest.tar.gz \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

EXPOSE 9000

CMD ["php-fpm7.4", "--nodaemonize"]
