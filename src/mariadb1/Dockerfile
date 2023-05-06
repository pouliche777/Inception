FROM alpine:3.14

RUN apk add --no-cache mariadb mariadb-client && \
    mkdir /run/mysqld && \
    chown mysql:mysql /run/mysqld
RUN rm -rf /etc/mysql/my.cnf
COPY /my.cnf /etc/mysql/my.cnf
COPY /script-maria.sh /bin/script-maria.sh



VOLUME /var/lib/mysql

EXPOSE 3306

RUN chmod +x /bin/script-maria.sh
CMD ["/bin/script-maria.sh"]
#CMD ["tail", "-f", "/dev/null"]

