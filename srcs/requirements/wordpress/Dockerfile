FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y php-fpm php-mysql curl unzip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*\
    && curl -O https://wordpress.org/latest.tar.gz \
    && tar -xzvf latest.tar.gz \
    && rm latest.tar.gz \
    && mv wordpress /var/www/html \
    && chown -R www-data:www-data /var/www/html

EXPOSE 9000

CMD ["php-fpm", "--nodaemonize"]