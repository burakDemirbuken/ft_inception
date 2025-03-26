#!/bin/sh

YELLOW='\033[33m'
GREEN='\033[32m'
RED='\033[31m'
BLUE='\033[34m'
RESET='\033[0m'

echo "${BLUE}Starting WordPress...${RESET}"

echo "${YELLOW}Waiting for MariaDB to start...${RESET}"
sleep 1

echo "${YELLOW}Loading secrets...${RESET}"

if [ -f /run/secrets/database ]; then
	. /run/secrets/database
else
	echo "${RED}No credentials file found. Please provide the database info.${RESET}"
	exit 1
fi

if [ -f /run/secrets/admin ]; then
	. /run/secrets/admin
else
	echo "${RED}No admin file found. Please provide the admin info.${RESET}"
	exit 1
fi

if [ -f /run/secrets/other_user ]; then
	. /run/secrets/other_user
else
	echo "${RED}No other user file found. Please provide the other user info.${RESET}"
	exit 1
fi

if [ ! -f  /var/www/html/wp-config.php ]; then

	echo "${YELLOW}Creating WordPress configuration...${RESET}"
	wp-cli core download --allow-root

	echo "${YELLOW}Creating database...${RESET}"
	wp-cli config create \
		--dbname=$DB_NAME \
		--dbuser=$DB_USERNAME \
		--dbpass=$DB_USER_PASSWORD \
		--dbhost=$DB_HOST \
		--allow-root

	echo "${YELLOW}Creating WordPress database...${RESET}"
	wp-cli core install \
		--url=$URL \
		--title=$TITLE \
		--admin_user=$ADMIN_USERNAME \
		--admin_password=$ADMIN_PASSWORD \
		--admin_email=$ADMIN_MAIL \
		--skip-email \
		--allow-root

	echo "${YELLOW}Creating other user...${RESET}"
	wp-cli user create \
		$OTHER_NAME \
		$OTHER_MAIL \
		--user_pass=$OTHER_PASSWORD \
		--allow-root

	else
		echo "${YELLOW}WordPress configuration already exists. Skipping...${RESET}"
fi

echo "${GREEN}WordPress setup completed successfully!${RESET}"

exec "$@"
