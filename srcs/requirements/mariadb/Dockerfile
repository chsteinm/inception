FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y mariadb-server \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /run/mysqld && chown mysql:mysql /run/mysqld

COPY my.cnf /etc/mysql/my.cnf

EXPOSE 3306

CMD ["mysqld"]
