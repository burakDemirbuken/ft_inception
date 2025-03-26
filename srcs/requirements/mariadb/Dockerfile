FROM debian:bullseye

RUN apt-get update && apt-get install -y mariadb-server

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY ./tool/mariadb.sh /usr/local/bin/mariadb.sh
RUN chmod +x /usr/local/bin/mariadb.sh

RUN mkdir -p /var/run/mysqld && \
chown -R mysql:mysql /var/lib/mysql /var/run/mysqld

ENTRYPOINT [ "/usr/local/bin/mariadb.sh" ]

CMD [ "mariadbd" ]
