#!/bin/bash

# Wait for the MariaDB container to be ready
while ! mariadb -h$MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE --port=3306 &>/dev/null; do
    echo "Waiting for the MariaDB container..."
    sleep 5
done
# Fonction pour vérifier si MariaDB est prêt
# check_mariadb_ready() {
#   mysqladmin ping -h 127.0.0.1 -u root --password="$MYSQL_PASSWORD" > /dev/null 2>&1
# }

# # Attendre que MariaDB soit prêt
# while ! check_mariadb_ready; do
#   echo "En attente de la disponibilité de MariaDB..."
#   sleep 1
# done
	#sed -i "s/listen = \/run\/php\/php7.3-fpm.sock/listen = 9000/" "/etc/php/7.3/fpm/pool.d/www.conf";
	chown -R www-data:www-data /var/www/*;
	chown -R 755 /var/www/*;
	mkdir -p /run/php/;
	touch /run/php/php7.3-fpm.pid;

# 	    sed -i "s/listen = \/run\/php\/php7.3-fpm.sock/listen = 9000/" "/etc/php/7.3/fpm/pool.d/www.conf"; : Cette commande utilise l'utilitaire sed pour rechercher et remplacer une ligne dans le fichier /etc/php/7.3/fpm/pool.d/www.conf. Elle remplace la valeur de listen qui était initialement définie sur /run/php/php7.3-fpm.sock par 9000. Cela configure PHP-FPM pour écouter sur le port 9000.

#     chown -R www-data:www-data /var/www/*; : Cette commande modifie le propriétaire et le groupe des fichiers et répertoires présents dans /var/www/ pour les définir sur www-data:www-data. Cela permet au serveur web (comme Nginx) d'accéder aux fichiers de votre site Web en tant qu'utilisateur www-data.

#     chown -R 755 /var/www/*; : Cette commande définira les permissions (droits d'accès) des fichiers et répertoires présents dans /var/www/ sur 755. Cela signifie que le propriétaire peut lire, écrire et exécuter les fichiers, tandis que les autres utilisateurs peuvent uniquement lire et exécuter les fichiers.

#     mkdir -p /run/php/; : Cette commande crée le répertoire /run/php/ s'il n'existe pas déjà. Ce répertoire est utilisé par PHP-FPM pour stocker certains fichiers temporaires et des informations sur le processus en cours d'exécution.

#     touch /run/php/php7.3-fpm.pid; : Cette commande crée un fichier vide php7.3-fpm.pid dans le répertoire /run/php/. Ce fichier est utilisé par PHP-FPM pour stocker le PID (identifiant du processus) du processus principal.

# Ces commandes sont généralement exécutées lors de la configuration initiale d'un serveur PHP-FPM pour s'assurer que les fichiers, les répertoires et les permissions sont correctement configurés.


if [ ! -f /var/www/html/wp-config.php ]; then
	mkdir -p /var/www/html
	wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar;
	chmod +x wp-cli.phar; 
	mv wp-cli.phar /usr/local/bin/wp;
	cd /var/www/html;
	wp core download --allow-root;
	
	# bouge mon fichier de configuration au bon endroit
	#mv /var/www/wp-config.php /var/www/html/
	wp config create --dbname=$MYSQL_DATABASE --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --dbhost=$MYSQL_HOST --dbcharset="utf8" --dbcollate="utf8_general_ci" --allow-root
	wp core install --allow-root --url=${WP_URL} --title=${WP_TITLE} --admin_user=${WP_ADMIN_LOGIN} --admin_password=${WP_ADMIN_PASSWORD} --admin_email=${WP_ADMIN_EMAIL}
	wp user create --allow-root ${WP_USER_LOGIN} ${WP_USER_EMAIL} --user_pass=${WP_USER_PASSWORD};
	echo "Wordpress is ready!"
else
	echo "Wordpress already exist"
    fi

exec "$@"