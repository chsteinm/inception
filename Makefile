DOCKER_COMPOSE = docker-compose
COMPOSE_FILE = srcs/docker-compose.yml

all: up

env:
	@if [ ! -f srcs/.env ]; then \
		echo "Creating .env file in srcs/"; \
		read -p "Enter MARIADB_DATABASE (default: wordpress): " mariadb_database; \
		read -p "Enter MARIADB_ROOT_PASSWORD (default: password): " mariadb_root_password; \
		read -p "Enter MARIADB_USER (default: db_user): " mariadb_user; \
		read -p "Enter MARIADB_PASSWORD (default: password): " mariadb_password; \
		read -p "Enter WP_ADMIN_USER (default: eval): " wp_admin_user; \
		read -p "Enter WP_ADMIN_PASSWORD (default: password): " wp_admin_password; \
		read -p "Enter WP_USER (default: user): " wp_user; \
		read -p "Enter WP_USER_PASSWORD (default: password): " wp_user_password; \
		echo "MARIADB_DATABASE=$${mariadb_database:-wordpress}" > srcs/.env; \
		echo "MARIADB_ROOT_PASSWORD=$${mariadb_root_password:-password}" >> srcs/.env; \
		echo "MARIADB_USER=$${mariadb_user:-db_user}" >> srcs/.env; \
		echo "MARIADB_PASSWORD=$${mariadb_password:-password}" >> srcs/.env; \
		echo "WP_ADMIN_USER=$${wp_admin_user:-eval}" >> srcs/.env; \
		echo "WP_ADMIN_PASSWORD=$${wp_admin_password:-password}" >> srcs/.env; \
		echo "WP_USER=$${wp_user:-user}" >> srcs/.env; \
		echo "WP_USER_PASSWORD=$${wp_user_password:-password}" >> srcs/.env; \
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

fclean: clean
	docker stop $$(docker ps -qa) 2>/dev/null || true;
	docker rm $$(docker ps -qa) 2>/dev/null || true;
	docker rmi -f $$(docker images -qa) 2>/dev/null || true;
	docker volume rm -f $$(docker volume ls -q) 2>/dev/null || true;
	docker network rm -f $$(docker network ls -q | grep -v 'bridge\|host\|none') 2>/dev/null || true;

.PHONY: all clean re up down build logs ps fclean check-pid env
