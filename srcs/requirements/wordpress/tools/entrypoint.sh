#!/bin/bash

mkdir -p /var/www/html
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

WP_CLI="/usr/local/bin/wp"
WP_PATH="/var/www/html"

until ${WP_CLI} db check --path=${WP_PATH} --allow-root; do
    echo "En attente de MariaDB..."
    sleep 5
done

if [ -z "$(ls -A /var/www/html)" ]; then
    echo "Téléchargement de WordPress..."
    wp core download --path=${WP_PATH} --allow-root
fi

if ! wp core is-installed --allow-root; then
    echo "Installation de WordPress..."
    wp core install \
        --url="https://chrstein.42.fr" \
        --title="inception" \
        --admin_user="${MYSQL_ADMIN_USER}" \
        --admin_password="${MYSQL_ADMIN_PASSWORD}" \
        --admin_email="admin@chrstein.42.fr" \
    	--path=${WP_PATH} \
        --allow-root 
fi

if ! wp user get "${MYSQL_USER}" --allow-root; then
    echo "Création de l’utilisateur ${MYSQL_USER}..."
    wp user create "${MYSQL_USER}" "user@chrstein.42.fr" \
        --role=subscriber \
        --user_pass="${MYSQL_PASSWORD}" \
    	--path=${WP_PATH} \
        --allow-root
fi

exec php-fpm7.4 --nodaemonize
