#!/bin/bash

mkdir -p /var/www/html
chown -R www-data:www-data /var/www/html

until wp db check --allow-root; do
    sleep 5
done

if [ ! -f /var/www/html/wp-settings.php ]; then
    sudo -u www-data wp core download --path=/var/www/html --allow-root
fi

if ! wp core is-installed --allow-root; then
    wp core install \
        --url="https://chrstein.42.fr" \
        --title="inception" \
        --admin_user="${MYSQL_ADMIN_USER}" \
        --admin_password="${MYSQL_ADMIN_PASSWORD}" \
        --admin_email="admin@chrstein.42.fr" \
        --allow-root
fi

if ! wp user get "${MYSQL_USER}" --allow-root; then
    wp user create "${MYSQL_USER}" "user@chrstein.42.fr" \
        --role=subscriber \
        --user_pass="${MYSQL_PASSWORD}" \
        --allow-root
fi

exec php-fpm7.4 --nodaemonize
