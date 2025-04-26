#!/bin/bash

mkdir -p /var/www/html
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

WP_PATH="/var/www/html"

if [ -z "$(ls -A /var/www/html)" ]; then
    echo "Téléchargement de WordPress..."
    wp core download --path=${WP_PATH} --allow-root
fi

cd ${WP_PATH}
if [ ! -f "${WP_PATH}/wp-config.php" ]; then
    echo "Création du fichier wp-config.php..."
    wp config create \
        --allow-root \
        --dbname="${MARIADB_DATABASE}" \
        --dbuser="${MARIADB_USER}" \
        --dbpass="${MARIADB_PASSWORD}" \
        --dbhost="mariadb" \
        --path=${WP_PATH}
fi

if ! wp core is-installed --allow-root; then
    echo "Installation de WordPress..."
    wp core install \
        --allow-root --skip-plugins --skip-themes \
        --url="https://chrstein.42.fr" \
        --title="inception" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="admin@chrstein.42.fr" \
    	--path=${WP_PATH} 
fi

if ! wp user get "${WP_USER}" --allow-root 2>/dev/null; then
    echo "Création de l’utilisateur ${WP_USER}..."
    wp user create "${WP_USER}" "user@chrstein.42.fr" \
        --role=subscriber \
        --user_pass="${WP_USER_PASSWORD}" \
    	--path=${WP_PATH} \
        --allow-root
fi

exec php-fpm7.4 --nodaemonize
