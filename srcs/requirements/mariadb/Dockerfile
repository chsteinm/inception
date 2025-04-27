FROM debian:bullseye

# Update package lists, install MariaDB server and client and clean up to reduce image size
RUN apt-get update -y && \
    apt-get install -y mariadb-server \
    mariadb-client && \
    rm -rf /var/lib/apt/lists/*

# Create the directory for MySQL runtime files and set ownership
RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

# Copy the database initialization script into the container
COPY ./tools/init-db.sh /init-db.sh
# Make the script executable
RUN chmod +x /init-db.sh

# Copy the custom MySQL configuration file into the container
COPY ./conf/my.cnf /etc/mysql/my.cnf

# Set the default command to run the initialization script
CMD ["/bin/bash", "-c", "/init-db.sh"]