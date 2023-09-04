DEVTOOLS_DIR := {{ DEVTOOLS_DIR }}

include $(DEVTOOLS_DIR)/configure/defaults.mk
include $(DEVTOOLS_DIR)/templates/make/common/lib.mk

include {{ SETTINGS }}

BRIDGE ?= {{ BRIDGE | default('dev-tools', true) }}
CONTAINER ?= {{ CONTAINER }}
CTX ?= {{ CTX | default('.', true) }}
DAEMONIZE ?= {{ DAEMONIZE | default('yes', true) }}
DOCKERFILE ?= {{ DOCKERFILE | default('', true) }}
DRIVER ?= {{ DRIVER | default('bridge', true) }}
ERR_IF_BRIDGE_EXISTS = {{ ERR_IF_BRIDGE_EXISTS | default('no', true) }}
IMAGE ?= {{ IMAGE | default('$(BASE_IMAGE)', true) }}
RESTART_POLICY ?= {{ RESTART_POLICY | default('no', true) }}
RM_AFTER_STOP ?= {{ RM_AFTER_STOP | default('yes', true) }}
SUBNET ?= {{ SUBNET | default('192.168.100.0/24', true) }}
TAG ?= {{ TAG | default('latest', true) }}

CHECK_DOCKER = docker ps 1>/dev/null

# ENVS
{% include 'common/j2/docker-envs.jinja2' %}

# BUILD ARGS
{% include 'common/j2/build_args.jinja2' %}

# PUBLUSH
{% include 'common/j2/publish.jinja2' %}

ifeq ($(DAEMONIZE),yes)
RUN_OPTS += -d
endif

ifeq ($(RM_AFTER_STOP),yes)
RUN_OPTS += --rm
endif

ifdef RESTART_POLICY
RUN_OPTS += --restart $(RESTART_POLICY)
endif

RUN_OPTS += --name $(CONTAINER)
RUN_OPTS += --network $(BRIDGE)
RUN_OPTS += $(PUBLISH_OPT)

.PHONY: network network-rm build run start stop rm rm-by-image rm-all prune purge

network:
	$(CHECK_DOCKER)
ifeq ($(strip $(ERR_IF_BRIDGE_EXISTS)),yes)
	[ -z "$$(docker network ls -q -f name=$(BRIDGE))" ] || false
endif
	[ -n "$$(docker network ls -q -f name=$(BRIDGE))" ] || docker network create --driver=$(DRIVER) --subnet=$(SUBNET) $(BRIDGE)

network-rm:
	$(CHECK_DOCKER)
	[ -z "$$(docker network ls -q -f name=$(BRIDGE))" ] || docker network rm $(BRIDGE)

build:
ifdef DOCKERFILE
	docker build -f $(DOCKERFILE) $(BUILD_ARGS) -t $(IMAGE) $(CTX)
else ifdef BASE_IMAGE
	docker pull $(BASE_IMAGE)
else
	$(error Neither DOCKERFILE nor BASE_IMAGE are defined.)
endif

run:
	$(CHECK_DOCKER)
	[ -n "$$(docker ps -aq -f status=running -f name=$(CONTAINER))" ] || docker run $(RUN_OPTS) $(ENVS) $(IMAGE)

start:
	$(CHECK_DOCKER)
	[ -n "$$(docker ps -aq -f status=running -f name=$(CONTAINER))" ] || docker start $(CONTAINER)

stop:
	$(CHECK_DOCKER)
	[ -z "$$(docker ps -aq -f status=running -f name=$(CONTAINER))" ] || docker stop $(CONTAINER)

rm:
	$(CHECK_DOCKER)
	[ -z "$$(docker ps -aq -f name=$(CONTAINER))" ] || docker rm -f $(CONTAINER)

rm-by-image:
	$(CHECK_DOCKER)
	[ -z "$$(docker ps -aq -f ancestor=$(IMAGE))" ] || docker rm -f "$$(docker ps -aq -f ancestor=$(IMAGE))"

rm-all:
	$(CHECK_DOCKER)
	[ -z "$$(docker ps -aq)" ] || docker rm -f $$(docker ps -aq)

prune: rm-all
	docker system prune -f
	docker volume prune -f
	docker network prune -f

purge: rm-all
	docker system prune -a -f --volumes
	docker volume prune -f
	docker network prune -f
	docker builder prune --force --all

status:
	{% raw %}
	docker ps --format "table {{.ID}} | {{.Status}}" -f name=$(CONTAINER))"
	{% endraw %}

connect:
	docker exec -ti $(CONTAINER) /bin/sh

clean:

distclean:
