#!/bin/sh
mysql_install_db
/etc/init.d/mysql start
mysqld --user=mysql --datadir=/var/lib/mysql --skip-networking &
pid="$!"

# Wait for the server to start up
while ! mysqladmin ping -hlocalhost --silent; do
  sleep 1
done

# Set up the required tables
mysql -u root <<EOF
  CREATE DATABASE IF NOT EXISTS mysql;
  USE mysql;
  CREATE TABLE IF NOT EXISTS user (
      Host varchar(255) NOT NULL,
      User varchar(255) NOT NULL,
      Password varchar(255) NOT NULL,
      PRIMARY KEY (Host,User)
  );
  INSERT INTO user VALUES ('localhost', 'root', PASSWORD('PouletChaud'));
  FLUSH PRIVILEGES;
EOF

# Stop the server
mysqladmin shutdown -u root -p'PouletChaud'

# Wait for the server to shut down
while mysqladmin ping -hlocalhost --silent; do
  sleep 1
done

# Start the server in normal mode
innodb_flush_method=normal
mysqld --user=mysql --datadir=/var/lib/mysql
