
all: file up

up: file
	@docker compose -f srcs/docker-compose.yml build
	@docker compose -f srcs/docker-compose.yml up -d

clean: down file_clean
	@docker system prune -a -f
	@docker volume prune -f
	@docker network prune -f

file:
	@mkdir -p ${HOME}/Desktop/wordpress
	@mkdir -p ${HOME}/Desktop/mariadb

down:
	@docker compose -f srcs/docker-compose.yml down

file_clean:
	@sudo rm -rf ${HOME}/Desktop/wordpress
	@sudo rm -rf ${HOME}/Desktop/mariadb

list:
	@docker ps -a

logs:
	@docker compose -f srcs/docker-compose.yml logs

rf: file_clean re

re: down up

.PHONY: all up clean down list logs re
