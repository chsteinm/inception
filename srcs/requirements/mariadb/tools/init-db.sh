#!/bin/bash

# List of required environment variables
REQUIRED_VARS=("MARIADB_ROOT_PASSWORD" "MARIADB_DATABASE" "MARIADB_USER" "MARIADB_PASSWORD")

# Check if all required environment variables are defined
for VAR in "${REQUIRED_VARS[@]}"; do
  if [ -z "${!VAR}" ]; then
    echo "Error: The environment variable $VAR is not defined."
    exit 1
  fi
done

# Start the MySQL server in the background
mysqld &

# Wait for MySQL to be ready (maximum 30 seconds)
for i in {1..30}; do
  mysqladmin ping --silent && break
  sleep 1
done

# Initialize the database and user
mysql -uroot -p"$MARIADB_ROOT_PASSWORD" <<EOF
CREATE DATABASE IF NOT EXISTS $MARIADB_DATABASE;
CREATE USER IF NOT EXISTS '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_PASSWORD';
GRANT ALL PRIVILEGES ON $MARIADB_DATABASE.* TO '$MARIADB_USER'@'%';
FLUSH PRIVILEGES;
EOF

# Shut down the MySQL server gracefully
mysqladmin shutdown

# Start the MySQL server in the foreground
exec mysqld