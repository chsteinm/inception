DOCKER_COMPOSE = docker-compose
COMPOSE_FILE = srcs/docker-compose.yml

all: up

env:
    @if [ ! -f srcs/.env ]; then \
        echo "Creating default .env file in srcs/"; \
        echo "MARIADB_DATABASE=wordpress" > srcs/.env; \
        echo "MARIADB_ROOT_PASSWORD=password" >> srcs/.env; \
        echo "MARIADB_USER=db_user" >> srcs/.env; \
        echo "MARIADB_PASSWORD=password" >> srcs/.env; \
        echo "WP_ADMIN_USER=eval" >> srcs/.env; \
        echo "WP_ADMIN_PASSWORD=password" >> srcs/.env; \
        echo "WP_USER=user" >> srcs/.env; \
    	echo "WP_USER_PASSWORD=password" >> srcs/.env; \
        echo ".env file created successfully."; \
    fi

up: env
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

check-pid:
	@$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) ps --services | while read service_name; do \
		container_id=$$(docker ps -q --filter "name=$$service_name"); \
		if [ -n "$$container_id" ]; then \
			echo "Processes for container $$service_name (ID: $$container_id):"; \
			docker exec $$container_id ps -e -o pid,comm; \
			echo ""; \
		else \
			echo "No running container found for service $$service_name."; \
		fi; \
	done

re: clean build up

fclean:
	docker stop $$(docker ps -qa) || true;
	docker rm $$(docker ps -qa) || true;
	docker rmi -f $$(docker images -qa) || true;
	docker volume rm -f $$(docker volume ls -q) || true;
	docker network rm -f $$(docker network ls -q | grep -v 'bridge\|host\|none') 2>/dev/null || true;
	sudo rm -rf /home/chrstein/data/wordpress/*
	sudo rm -rf /home/chrstein/data/mysql/*

.PHONY: all clean re up down build logs ps fclean check-pid
