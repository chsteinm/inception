DOCKER_COMPOSE = docker-compose
COMPOSE_FILE = docker-compose.yml

all: up

up:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) up -d

down:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) down

clean:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) down -v --remove-orphans

build:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) build

logs:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) logs -f

ps:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) ps

re: clean up

.PHONY: all clean re up down build logs ps