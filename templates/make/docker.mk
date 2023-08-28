DAEMONIZE ?= {{ DAEMONIZE }}
BRIDGE ?= {{ BRIDGE }}
CONTAINER ?= {{ CONTAINER }}
CTX ?= {{ CTX }}
DOCKERFILE ?= {{ DOCKERFILE }}
DRIVER ?= {{ DRIVER }}
ERR_IF_BRIDGE_EXISTS = {{ ERR_IF_BRIDGE_EXISTS }}
IMAGE ?= {{ IMAGE }}
SUBNET ?= {{ SUBNET }}
PUBLISH ?= {{ PUBLISH }}
TAG ?= {{ TAG }}

ifeq ($(DAEMONIZE),yes)
RUN_OPTS += -d
endif

RUN_OPTS += --name $(CONTAINER)
RUN_OPTS += --network $(BRIDGE)
RUN_OPTS += $(PUBLISH_OPT)

{% set args = [] -%}
{% if BUILD_ARGS -%}
{% for item in BUILD_ARGS.split(' ') -%}
{{ item }} = {{ env[item] }}
{% endfor -%}
{% for item in BUILD_ARGS.split(' ') -%}
{% if env[item] -%}
{% do args.append("{}=$({})".format(item, item)) -%}
{% endif -%}
{% endfor -%}
{% endif -%}

{% if args %}
BUILD_ARGS ?= \
    --build-arg {{ args|join(' \\\n    --build-arg ') }}
{% endif %}

{% set e = [] -%}
{% if ENVS -%}
{% for item in ENVS.split(' ') -%}
{{ item }} = {{ env[item] }}
{% endfor -%}
{% for item in ENVS.split(' ') -%}
{% if env[item] -%}
{% do e.append("{}=$({})".format(item, item)) -%}
{% endif -%}
{% endfor -%}
{% endif -%}

{% if e %}
ENVS ?= \
    --env {{ e|join(' \\\n    --env ') }}
{% endif %}

ifdef PUBLISH
    PUBLISH_OPT = --publish $(PUBLISH)
else
    PUBLISH_OPT =
endif

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
