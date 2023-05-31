FROM debian:buster

RUN apt-get update
RUN apt-get install -y mariadb-server

EXPOSE 3306

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/
COPY ./maria-script.sh .
#COPY ./tools /var/www/

# Replace the placeholders in the initial_db.sql file with the environment variables
# RUN sed -i "s/wordpressdb/$MYSQL_DATABASE/g" /var/www/initial_db.sql
# RUN sed -i "s/'slord'@'%' IDENTIFIED BY '12345'/'$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD'/g" /var/www/initial_db.sql

RUN mkdir -p /run/mysqld;\
    chown -R mysql:mysql /run/mysqld;\
    chown -R mysql:mysql /var/lib/mysql;\
    mysql_install_db --basedir=/usr --user=$MYSQL_USER --datadir=/var/lib/mysql;\
    chmod +x ./maria-script.sh

ENTRYPOINT ["./maria-script.sh"]

CMD ["mysqld"]
# RUN service mysql start && mysql < /var/www/initial_db.sql && rm -f /var/www/initial_db.sql;

# CMD ["mysqld"]