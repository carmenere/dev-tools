BRIDGE ?= {{ BRIDGE | default('dev-tools', true) }}
CONTAINER ?= {{ CONTAINER | default('', true) }}
CTX ?= {{ CTX | default('.', true) }}
DAEMONIZE ?= {{ DAEMONIZE | default('yes', true) }}
DOCKERFILE ?= {{ DOCKERFILE | default('', true) }}
DRIVER ?= {{ DRIVER | default('bridge', true) }}
ERR_IF_BRIDGE_EXISTS = {{ ERR_IF_BRIDGE_EXISTS | default('yes', true) }}
IMAGE ?= {{ IMAGE | default('', true) }}
RESTART_POLICY ?= {{ RESTART_POLICY | default('no', true) }}
RM_AFTER_STOP ?= {{ RM_AFTER_STOP | default('yes', true) }}
SUBNET ?= {{ SUBNET | default('192.168.100.0/24', true) }}
TAG ?= {{ TAG | default('latest', true) }}

{% include 'common/lib.mk' %}
{% include 'common/envs.j2' %}
{% include 'common/build_args.j2' %}
{% include 'common/publish.j2' %}

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
ifeq ($(strip $(ERR_IF_BRIDGE_EXISTS)),yes)
	[ -z "$$(docker network ls -q -f name=$(BRIDGE))" ] || false
endif
	[ -n "$$(docker network ls -q -f name=$(BRIDGE))" ] || docker network create --driver=$(DRIVER) --subnet=$(SUBNET) $(BRIDGE)

network-rm:
	[ -z "$$(docker network ls -q -f name=$(BRIDGE))" ] || docker network rm $(BRIDGE)

build:
ifdef DOCKERFILE
	docker build -f $(DOCKERFILE) $(BUILD_ARGS) -t $(IMAGE) $(CTX)
else ifdef BASE_IMAGE
	docker pull $(BASE_IMAGE)
else
	$(error Neither DOCKERFILE nor BASE_IMAGE are defined.)
endif

run: build network
	docker run $(RUN_OPTS) $(ENVS) $(IMAGE)

start: 
	[ -n "$$(docker ps -aq -f status=running -f name=$(CONTAINER))" ] || docker start $(CONTAINER)

stop:
	[ -z "$$(docker ps -aq -f status=running -f name=$(CONTAINER))" ] || docker stop $(CONTAINER)

rm:
	[ -z "$$(docker ps -aq -f name=$(CONTAINER))" ] || docker rm -f $(CONTAINER)

rm-by-image:
	[ -z "$$(docker ps -aq -f ancestor=$(IMAGE))" ] || docker rm -f "$$(docker ps -aq -f ancestor=$(IMAGE))"

rm-all:
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

clean: rm

distclean: rm
