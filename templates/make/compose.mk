TOPDIR := $(shell pwd)

DAEMONIZE ?= {{ DAEMONIZE }}
FORCE_RECREATE ?= {{ FORCE_RECREATE }}
NO_CACHE ?= {{ NO_CACHE }}
PROJECT ?= {{ PROJECT }}
RM_ALL ?= {{ RM_ALL }}
RM_FORCE ?= {{ RM_FORCE }}
RM_ON_UP ?= {{ RM_ON_UP }}
RM_STOP ?= {{ RM_STOP }}
RM_VOLUMES ?= {{ RM_VOLUMES }}
TIMEOUT ?= {{ TIMEOUT }}
YAML ?= {{ YAML }}
PURGE_ON_BUILD ?= {{ PURGE_ON_BUILD }}

ifdef PROJECT 
COMPOSE_OPTS += -p $(PROJECT)
endif

ifneq ($(RM_FORCE),no)
RM_OPTS += --force
endif

ifneq ($(RM_STOP),no)
RM_OPTS += --stop
endif

ifeq ($(RM_VOLUMES),yes)
RM_OPTS += --volumes
endif

ifeq ($(RM_ALL),yes)
RM_OPTS += --all
endif

ifeq ($(RM_ALL),yes)
RM_OPTS += --all
endif

ifeq ($(NO_CACHE),yes)
BUILD_OPTS += --no-cache
endif

ifneq ($(FORCE_RECREATE),no)
UP_OPTS += --force-recreate
endif

ifeq ($(DAEMONIZE),yes)
UP_OPTS += -d
endif

ifdef TIMEOUT 
DOWN_OPTS += --timeout $(TIMEOUT)
endif

ifeq ($(RM_ON_UP),yes)
UP_DEPS += rm 
endif

ifneq ($(PURGE_ON_BUILD),no)
UP_DEPS += purge 
endif

UP_DEPS += build
# UP_DEPS += pull

.PHONY: pull build up down start stop rm

pull:
	docker-compose -f $(YAML) $(COMPOSE_OPTS) pull

build: 
	docker-compose -f $(YAML) $(COMPOSE_OPTS) build $(BUILD_OPTS)

up: $(UP_DEPS)
	docker-compose -f $(YAML) $(COMPOSE_OPTS) up $(UP_OPTS)

down:
	docker-compose -f $(YAML) $(COMPOSE_OPTS) down $(DOWN_OPTS)

start:
	docker-compose -f $(YAML) $(COMPOSE_OPTS) start

stop:
	docker-compose -f $(YAML) $(COMPOSE_OPTS) stop

rm:
	docker-compose -f $(YAML) $(COMPOSE_OPTS) rm $(RM_OPTS)

purge:
	[ -z "$$(docker ps -aq)" ] || docker rm -f $$(docker ps -aq)
	docker system prune -a -f --volumes
	docker volume prune -f
	docker network prune -f
	docker builder prune --force --all
