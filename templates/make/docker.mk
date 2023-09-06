DEVTOOLS_DIR := {{ DEVTOOLS_DIR }}

include $(DEVTOOLS_DIR)/lib.mk

BRIDGE ?= {{ BRIDGE | default('dev-tools', true) }}
CONTAINER ?= {{ CONTAINER }}
CTX ?= {{ CTX | default('.', true) }}
DAEMONIZE ?= {{ DAEMONIZE | default('yes', true) }}
DOCKERFILE ?= {{ DOCKERFILE | default('', true) }}
DRIVER ?= {{ DRIVER | default('bridge', true) }}
ERR_IF_BRIDGE_EXISTS = {{ ERR_IF_BRIDGE_EXISTS | default('no', true) }}
IMAGE ?= {{ IMAGE | default('', true) }}
RESTART_POLICY ?= {{ RESTART_POLICY | default('no', true) }}
RM_AFTER_STOP ?= {{ RM_AFTER_STOP | default('no', true) }}
SUBNET ?= {{ SUBNET | default('192.168.100.0/24', true) }}
TAG ?= {{ TAG | default('latest', true) }}
COMMAND ?= {{ COMMAND | default('', true) }}
SH ?= {{ SH | default(d['SH'], true) }}

CHECK_DOCKER = docker ps 1>/dev/null

# ENVS
{% include 'common/j2/docker-envs.jinja2' %}

# OPTS
{% include 'common/j2/opts.jinja2' %}

# BUILD ARGS
{% include 'common/j2/build_args.jinja2' %}

# PUBLUSH
{% include 'common/j2/publish.jinja2' %}

ifdef IMAGE
    IMG = $(IMAGE)
else ifdef BASE_IMAGE
    IMG = $(BASE_IMAGE)
else
    $(error Neither IMAGE nor BASE_IMAGE are defined.)
endif

ifeq ($(DAEMONIZE),yes)
D += -d
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
	[ -z "$$(docker network ls -q --filter name='^$(BRIDGE)$$')" ] || false
endif
	[ -n "$$(docker network ls -q --filter name='^$(BRIDGE)$$')" ] || docker network create --driver=$(DRIVER) --subnet=$(SUBNET) $(BRIDGE)

network-rm:
	$(CHECK_DOCKER)
	[ -z "$$(docker network ls -q --filter name='^$(BRIDGE)$$')" ] || docker network rm $(BRIDGE)

build:
ifdef DOCKERFILE
	docker build -f $(DOCKERFILE) $(BUILD_ARGS) -t $(IMG) $(CTX)
else ifdef BASE_IMAGE
	docker pull $(BASE_IMAGE)
else
	$(error Neither DOCKERFILE nor BASE_IMAGE are defined.)
endif

run: network
	$(CHECK_DOCKER)
	[ -n "$$(docker ps -aq --filter name='^$(CONTAINER)$$')" ] || docker run $(RUN_OPTS) $(D) $(ENVS) $(IMG) $(COMMAND)

create: network
	$(CHECK_DOCKER)
	[ -n "$$(docker ps -aq --filter name='^$(CONTAINER)$$')" ] || docker create $(RUN_OPTS) $(ENVS) $(IMG) $(COMMAND)

start: create
	$(CHECK_DOCKER)
	[ -z "$$(docker ps -aq --filter name='^$(CONTAINER)$$') --filter status=exited --filter status=created" ] || docker start $(CONTAINER)

stop:
	$(CHECK_DOCKER)
	[ -z "$$(docker ps -aq --filter name='^$(CONTAINER)$$' --filter status=running)" ] || docker stop $(CONTAINER)

rm:
	$(CHECK_DOCKER)
	[ -z "$$(docker ps -aq --filter name='^$(CONTAINER)$$')" ] || docker rm --force $(CONTAINER)

rm-by-image:
	$(CHECK_DOCKER)
	[ -z "$$(docker ps -aq --filter ancestor='^$(IMG)$$')" ] || docker rm --force "$$(docker ps -aq --filter ancestor='^$(IMG)$$')"

rm-all:
	$(CHECK_DOCKER)
	[ -z "$$(docker ps -aq)" ] || docker rm --force $$(docker ps -aq)

prune: rm-all
	docker system prune --force
	docker volume prune --force
	docker network prune --force

purge: rm-all
	docker system prune --force --all --volumes
	docker volume prune --force
	docker network prune --force
	docker builder prune --force --all

status:
	{% raw %}
	docker ps --format "table {{.ID}} | {{.Status}}" --format name='^$(CONTAINER)$$')"
	{% endraw %}

connect:
	docker exec -ti $(CONTAINER) $(SH)

clean:

distclean:
