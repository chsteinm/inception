FROM debian:bullseye

RUN mkdir -p /run/php && chown -R www-data:www-data /run/php

RUN apt-get update && apt-get install -y \
wget \
tar \
php \
php-fpm \
php-mysql \
curl \
&& rm -rf /var/lib/apt/lists/*

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

RUN mkdir -p /var/www/html \
&& wget https://wordpress.org/latest.tar.gz \
&& tar -xzf latest.tar.gz --strip-components=1 -C /var/www/html \
&& rm latest.tar.gz

COPY ./tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
