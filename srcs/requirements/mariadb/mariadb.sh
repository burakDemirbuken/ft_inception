#!bin/sh

export MYSQL_PASSWORD=$(cat /run/secrets/db_password)
export MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
export MYSQL_USER=$(grep MYSQL_USER /run/secrets/credentials | cut -d '=' -f2 | tr -d '[:space:]')
export MYSQL_DATABASE=$(grep MYSQL_DATABASE /run/secrets/credentials | cut -d '=' -f2 | tr -d '[:space:]')

