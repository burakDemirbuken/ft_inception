NGNIX_NAME = ngnix
WORDPRESS_NAME = wordpress
MARIADB_NAME = mariadb

all: build

build:
	@sudo docker compose -f srcs/docker-compose.yml up --build

clean: stop
	@sudo docker system prune -a -f

stop:
	@sudo docker compose -f srcs/docker-compose.yml down

list:
	@sudo docker ps -a

re: stop build
