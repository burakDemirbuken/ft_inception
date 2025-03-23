#!/bin/sh

if [ -f /run/secrets/credentials ]; then
	. /run/secrets/credentials
else
	echo "No credentials file found. Please provide the credentials."
	exit 1
fi

if [ -f /run/secrets/db_password ]; then
	. /run/secrets/db_password
else
	echo "No db_password file found. Please provide the db_password."
	exit 1
fi

echo $DB_NAME
echo $DB_USERNAME
echo $DB_PASSWORD
echo $DB_HOST

if [ ! -f  /var/www/html/wp-config.php ]; then

	wp-cli core download --allow-root

	wp-cli config create \
		--dbname=$DB_NAME \
		--dbuser=$DB_USERNAME \
		--dbpass=$DB_PASSWORD \
		--dbhost=$DB_HOST \
		--allow-root

	wp-cli core install \
		--url=bdemirbu.42.tr \
		--title=NABERMUDUR \
		--admin_user=burak_admin \
		--admin_password=NABERMUDUR \
		--admin_email=NABERMUDUR@gmail.com \
		--skip-email \
		--allow-root

	wp-cli user create "burak" \
		"NABERMUDUR@gmail.com" \
		--user_pass="NABERMUDUR" \
		--allow-root

fi

exec "$@"
