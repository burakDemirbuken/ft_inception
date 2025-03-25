#!/bin/sh

CYAN='\033[36m'
GREEN='\033[32m'
RED='\033[31m'
BLUE='\033[34m'
RESET='\033[0m'

echo "${CYAN}Loading secrets...${RESET}"
if [ -f /run/secrets/database ]; then
	. /run/secrets/database
else
	echo "${RED}No credentials file found. Please provide the credentials.${RESET}"
	exit 1
fi

if [ -z "${DB_NAME}" ] || [ -z "${DB_USERNAME}" ] || [ -z "${DB_PASSWORD}" ]; then
	echo "${RED}Please set DB_NAME, DB_USERNAME, DB_PASSWORD, and DB_ROOT_PASSWORD environment variables.${RESET}"
	exit 1
fi

service mariadb start

while ! mariadb-admin ping -h localhost -u root --silent; do
	echo "${CYAN}Waiting for MariaDB to start...${RESET}"
    sleep 1
done

echo "${GREEN}MariaDB started successfully!${RESET}"

mariadb -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
echo "${GREEN}Database $DB_NAME created successfully!${RESET}"

mariadb -e "CREATE USER IF NOT EXISTS '$DB_USERNAME'@'%' IDENTIFIED BY '$DB_PASSWORD';"
echo "${GREEN}User $DB_USERNAME created successfully!${RESET}"

mariadb -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USERNAME'@'%';"
echo "${GREEN}Granted all privileges on $DB_NAME to $DB_USERNAME!${RESET}"

mariadb -e "FLUSH PRIVILEGES;"

service mariadb stop

echo "${GREEN}MariaDB setup completed successfully!${RESET}"
echo "${BLUE}Starting MariaDB...${RESET}"


exec "$@"
