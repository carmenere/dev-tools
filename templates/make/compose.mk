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

BUILD_DEPS += purge

UP_DEPS += force-rm
# UP_DEPS += build
# UP_DEPS += pull

.PHONY: pull build up down start stop rm force-rm prune purge

pull:
	docker-compose -f $(YAML) pull

build: $(BUILD_DEPS)
	docker-compose -f $(YAML) build $(BUILD_OPTS)

up: $(UP_DEPS)
	docker-compose -f $(YAML) up $(UP_OPTS)

down:
	docker-compose -f $(YAML) down $(DOWN_OPTS)

start:
	docker-compose -f $(YAML) start

stop:
	docker-compose -f $(YAML) stop

rm:
	docker-compose -f $(YAML) rm $(RM_OPTS)

force-rm:
	[ -z "$$(docker ps -aq)" ] || docker rm -f $$(docker ps -aq)

prune: force-rm
	docker system prune -f
	docker volume prune -f
	docker network prune -f

purge: force-rm
	docker system prune -a -f --volumes
	docker volume prune -f
	docker network prune -f
	docker builder prune --force --all
