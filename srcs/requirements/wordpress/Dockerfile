FROM debian:bullseye

RUN apt-get update && apt-get install -y \
wget \
tar \
php \
php-fpm \
php-mysql \
&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/html \
&& wget https://wordpress.org/latest.tar.gz \
&& tar -xzf latest.tar.gz --strip-components=1 -C /var/www/html \
&& rm latest.tar.gz

COPY ./tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

# WORKDIR /var/www/html