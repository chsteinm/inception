DOCKER_COMPOSE = docker-compose
COMPOSE_FILE = srcs/docker-compose.yml

all: up

up:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) up -d

down:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) down

clean:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) down -v --remove-orphans
	docker system prune -f --volumes
	sudo rm -rf /home/chrstein/data/wordpress/*
	sudo rm -rf /home/chrstein/data/mysql/*

build:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) build

logs:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) logs -f

ps:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) ps

re: clean build up

megaClean:
	docker stop $$(docker ps -qa);
	docker rm $$(docker ps -qa);
	docker rmi -f $$(docker images -qa);
	docker volume rm -f $$(docker volume ls -q);
	docker network rm -f $$(docker network ls -q) 2>/dev/null

.PHONY: all clean re up down build logs ps megaClean
