#!/bin/sh

CYAN='\033[36m'
GREEN='\033[32m'
RED='\033[31m'
BLUE='\033[34m'
RESET='\033[0m'

chown -R mysql:mysql /var/lib/mysql /var/run/mysqld
chmod -R 755 /var/lib/mysql

echo "${CYAN}Loading secrets...${RESET}"
if [ -f /run/secrets/database ]; then
	. /run/secrets/database
else
	echo "${RED}No credentials file found. Please provide the credentials.${RESET}"
	exit 1
fi

if [ -z "${DB_NAME}" ] || [ -z "${DB_USERNAME}" ] || [ -z "${DB_USER_PASSWORD}" ]; then
	echo "${RED}Please set DB_NAME, DB_USERNAME, and DB_USER_PASSWORD environment variables.${RESET}"
	exit 1
fi

service mariadb start

while ! mariadb-admin ping -h localhost -u root --silent; do
	echo "${CYAN}Waiting for MariaDB to start...${RESET}"
	sleep 1
done

echo "${GREEN}MariaDB started successfully!${RESET}"

# **Database kontrolü**
DB_EXISTS=$(mariadb -Nse "SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = '$DB_NAME';")

if [ -z "$DB_EXISTS" ]; then
	echo "${CYAN}Database $DB_NAME does not exist. Creating...${RESET}"
	mariadb -e "CREATE DATABASE $DB_NAME;"
	echo "${GREEN}Database $DB_NAME created successfully!${RESET}"
else
	echo "${CYAN}Database $DB_NAME already exists. Skipping database creation...${RESET}"
fi

# **Kullanıcı kontrolü**
USER_EXISTS=$(mariadb -Nse "SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user = '$DB_USERNAME');")

if [ "$USER_EXISTS" -eq 0 ]; then
	echo "${CYAN}User $DB_USERNAME does not exist. Creating...${RESET}"
	mariadb -e "CREATE USER '$DB_USERNAME'@'%' IDENTIFIED BY '$DB_USER_PASSWORD';"
	mariadb -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USERNAME'@'%';"
	mariadb -e "FLUSH PRIVILEGES;"
	echo "${GREEN}User $DB_USERNAME created and granted privileges!${RESET}"
else
	echo "${CYAN}User $DB_USERNAME already exists. Skipping user creation...${RESET}"
fi

sleep 1

service mariadb stop

echo "${GREEN}MariaDB setup completed successfully!${RESET}"
echo "${BLUE}Starting MariaDB...${RESET}"

exec "$@"
