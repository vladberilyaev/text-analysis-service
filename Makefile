-include .env

# Имя проекта
PROJECT_NAME ?= text-analysis-service

# Версия проекта
VERSION = $(shell git describe --tags --exact-match 2> /dev/null || git symbolic-ref -q --short HEAD || git rev-parse --short HEAD || echo "noversion")

# Путь к Docker-образу
REGISTRY_IMAGE = $(PROJECT_NAME):$(VERSION)

# Сетевое окружение
NETWORK ?= analysis_default

# Порт для приложения
PORT ?= 5000

# Список переменных окружения для передачи в контейнер
DOCKER_SETTINGS = \
    --env PORT=$(PORT)

build:
	docker build -t $(REGISTRY_IMAGE) .

run: down
	@docker network create $(NETWORK) || true
	docker run --rm --name $(PROJECT_NAME) \
	    -p $(PORT):$(PORT) \
	    --network $(NETWORK) \
	    -v $(shell pwd):/app \
	    $(DOCKER_SETTINGS) \
	    $(REGISTRY_IMAGE)

dev: build run

down:
	docker stop $(docker ps -q --filter ancestor=$(REGISTRY_IMAGE)) || true && docker rm $(docker ps -a -q --filter ancestor=$(REGISTRY_IMAGE)) || true

env:
	@echo "# Порт для приложения" >> .env
	@echo "PORT=$(PORT)" >> .env

console:
	docker exec -it $(PROJECT_NAME) /bin/sh
