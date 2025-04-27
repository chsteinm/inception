#!/bin/bash

# List of required environment variables
REQUIRED_VARS=("MARIADB_DATABASE" "MARIADB_USER" "MARIADB_PASSWORD" "WP_ADMIN_USER" "WP_ADMIN_PASSWORD" "WP_USER" "WP_USER_PASSWORD")

# Check if all required environment variables are defined
for VAR in "${REQUIRED_VARS[@]}"; do
    if [ -z "${!VAR}" ]; then
        echo "Error: The environment variable $VAR is not defined."
        exit 1
    fi
done

# Create the WordPress directory if it doesn't exist
mkdir -p /var/www/html

# Set ownership and permissions for the WordPress directory
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# Define the WordPress installation path
WP_PATH="/var/www/html"

# Download WordPress core files if the directory is empty
if [ -z "$(ls -A /var/www/html)" ]; then
    echo "Downloading WordPress..."
    wp core download --path=${WP_PATH} --allow-root
fi

# Change to the WordPress directory
cd ${WP_PATH}

# Create the wp-config.php file if it doesn't exist
if [ ! -f "${WP_PATH}/wp-config.php" ]; then
    echo "Creating the wp-config.php file..."
    wp config create \
        --allow-root \
        --dbname="${MARIADB_DATABASE}" \
        --dbuser="${MARIADB_USER}" \
        --dbpass="${MARIADB_PASSWORD}" \
        --dbhost="mariadb" \
        --path=${WP_PATH}
fi

# Install WordPress if it is not already installed
if ! wp core is-installed --allow-root; then
    echo "Installing WordPress..."
    wp core install \
        --allow-root --skip-plugins --skip-themes \
        --url="https://chrstein.42.fr" \
        --title="inception" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="admin@chrstein.42.fr" \
        --path=${WP_PATH} 
fi

# Create a new WordPress user if it doesn't already exist
if ! wp user get "${WP_USER}" --allow-root 2>/dev/null; then
    echo "Creating the user ${WP_USER}..."
    wp user create "${WP_USER}" "user@chrstein.42.fr" \
        --role=subscriber \
        --user_pass="${WP_USER_PASSWORD}" \
        --path=${WP_PATH} \
        --allow-root
fi

# Start PHP-FPM in the foreground
exec php-fpm7.4 --nodaemonize