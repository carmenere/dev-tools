TOPDIR := $(shell pwd)

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

{% if ENVS -%}
{% endif -%}

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
ifdef PUBLISH
    PUBLISH_OPT = --publish $(PUBLISH)
else
    PUBLISH_OPT =
endif

.PHONY: network network-rm build run start stop rm rm-by-image prune prune-all

network:
	@echo ERR_IF_BRIDGE_EXISTS = $(ERR_IF_BRIDGE_EXISTS)
ifeq ($(strip $(ERR_IF_BRIDGE_EXISTS)),yes)
	[ -z "docker network ls -q -f name=$(BRIDGE)" ] || false
endif
	[ -n "docker network ls -q -f name=$(BRIDGE)" ] || docker network create --driver=$(DRIVER) --subnet=$(SUBNET) $(BRIDGE)

network-rm:
	[ -z "docker network ls -q -f name=$(BRIDGE)" ] || docker network rm $(BRIDGE)

build:
ifdef DOCKERFILE
	docker build -f $(DOCKERFILE) $(BUILD_ARGS) -t $(IMAGE) $(CTX)
else ifdef BASE_IMAGE
	docker pull $(BASE_IMAGE)
else
	$(error Neither DOCKERFILE nor BASE_IMAGE are defined.)
endif

run: build network
	docker run --name $(CONTAINER) --network $(BRIDGE) $(PUBLISH_OPT) $(IMAGE)

start: 
	[ -n "$$(docker ps -q -f status=running -f name=$(CONTAINER))" ] || docker start $(CONTAINER)

stop:
	[ -z "$$(docker ps -q -f status=running -f name=$(CONTAINER))" ] || docker stop $(CONTAINER)

rm:
	[ -z "$$(docker ps -q -f name=$(CONTAINER))" ] || docker rm -f $(CONTAINER)

rm-by-image:
	[ -z "$$(docker ps -q -f ancestor=$(IMAGE))" ] || docker rm -f "$$(docker ps -q -f ancestor=$(IMAGE))"

prune:
	docker system prune -f
	docker volume prune -f
	docker network prune -f

purge:
	[ -z "$$(docker ps -aq)" ] || docker rm -f $$(docker ps -aq)
	docker system prune -a -f --volumes
	docker volume prune -f
	docker network prune -f
	docker builder prune --force --all
