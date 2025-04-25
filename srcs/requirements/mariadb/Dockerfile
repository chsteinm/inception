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

COPY ./conf/my.cnf /etc/mysql/my.cnf

CMD ["/bin/bash", "-c", "/init-db.sh"]
