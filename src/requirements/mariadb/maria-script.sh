#!/bin/bash

set -e

mysqld --bootstrap << EOF
USE mysql;
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED by '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
FLUSH PRIVILEGES;
EOF

exec "$@"

#comandes pour naviguer dans ma base de donnees via le terminal
# se connecter :  mysql -u "USERNAME" -p
# choisir la database : USE "DATABASE NAME";
# SHOW TABLES;
# SELECT * FORM "table name";  Je peux remplacer le * par la colonne precise que je veux afficher, par exemple colunm1.
#il est aussi possible de modfifer le contenu de la base de donees : par exemple, UPDATE wp_comments SET comment_content = 'test terminal';
