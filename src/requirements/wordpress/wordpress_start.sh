#!/bin/sh

#Wait for the MariaDB container to be ready
while ! mariadb -h$MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE --port=3306 &>/dev/null; do
    echo "Waiting for the MariaDB container..."
    sleep 20
done
sleep 20
if [ ! -f "/var/www/html/wp-config.php" ]; then
    echo "WordPress is not installed. Installing..."
    wp core download --allow-root
    wp config create --dbname=$MYSQL_DATABASE --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --dbhost=$MYSQL_HOST --dbcharset="utf8" --dbcollate="utf8_general_ci" --allow-root
    wp core install --url=$WORDPRESS_URL --title="$WORDPRESS_TITLE" --admin_user=$WORDPRESS_ADMIN_USER --admin_password=$WORDPRESS_ADMIN_PASSWORD --admin_email=$WORDPRESS_ADMIN_EMAIL --skip-email --allow-root 
    wp theme install yith-wonder --allow-root
	wp theme activate yith-wonder --allow-root
    wp user create $WORDPRESS_EDITOR_USER $WORDPRESS_EDITOR_EMAIL --role=author --user_pass=$WORDPRESS_EDITOR_PASSWORD --allow-root

else
    echo "WordPress is already installed."
fi
echo "Starting the server."

# Start PHP-FPM
exec "$@"