
all: build

build:
	@docker compose -f srcs/docker-compose.yml build
	@docker compose -f srcs/docker-compose.yml up -d

clean: stop
	@docker system prune -a -f

stop:
	@docker compose -f srcs/docker-compose.yml down

list:
	@docker ps -a

logs:
	@docker compose -f srcs/docker-compose.yml logs

re: stop build
