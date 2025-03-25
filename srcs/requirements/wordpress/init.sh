#!/bin/sh

if [ -f /run/secrets/database ]; then
	. /run/secrets/database
else
	echo "No credentials file found. Please provide the database info."
	exit 1
fi

if [ -f /run/secrets/admin ]; then
	. /run/secrets/admin
else
	echo "No admin file found. Please provide the admin info."
	exit 1
fi

if [ -f /run/secrets/sqluser ]; then
	. /run/secrets/sqluser
else
	echo "No sqluser file found. Please provide the sqluser info."
	exit 1
fi

if [ ! -f  /var/www/html/wp-config.php ]; then

	wp-cli core download --allow-root

	wp-cli config create \
		--dbname=$DB_NAME \
		--dbuser=$DB_USERNAME \
		--dbpass=$DB_PASSWORD \
		--dbhost=$DB_HOST \
		--allow-root

	wp-cli core install \
		--url=$URL \
		--title=$TITLE \
		--admin_user=$ADMIN_USERNAME \
		--admin_password=$ADMIN_PASSWORD \
		--admin_email=$ADMIN_MAIL \
		--skip-email \
		--allow-root

fi

exec "$@"
