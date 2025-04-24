FROM debian:bullseye

ARG MYSQL_ADMIN_PASSWORD
ARG MYSQL_ADMIN_USER
ARG MYSQL_DATABASE
ARG MYSQL_PASSWORD
ARG MYSQL_USER

RUN apt-get update -y && \
    apt-get install -y mariadb-server \
    mariadb-client && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld


COPY ./tools/init-db.sh /init-db.sh
RUN chmod +x /init-db.sh

# RUN service mariadb start \
#     && mariadb -u root \
#     -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};" \
#     -e "CREATE USER IF NOT EXISTS '${MYSQL_ADMIN_USER}' IDENTIFIED BY '${MYSQL_ADMIN_PASSWORD}';" \
#     -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}';" \
#     -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';" \
#     -e "FLUSH PRIVILEGES;"

#RUN sed -i 's/^bind-address\s*=.*$/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

# ENTRYPOINT [ "bash"]
# ENTRYPOINT [ "mariadbd", "--bind-address=0.0.0.0"]
CMD ["/bin/bash", "-c", "/init-db.sh && exec mysqld_safe"]
