DEVTOOLS_DIR := {{ DEVTOOLS_DIR }}

include $(DEVTOOLS_DIR)/lib.mk

ADMIN ?= {{ ADMIN | default(d['CH_ADMIN'], true) }}
ADMIN_PASSWORD ?= {{ ADMIN_PASSWORD | default(d['CH_ADMIN_PASSWORD'], true) }}
MAJOR ?= {{ MAJOR | default('23.5', true) }}
MINOR ?= {{ MINOR | default('', true) }}
OS ?= {{ OS | default(d['OS'], true) }}
SERVICE ?= {{ SERVICE | default('clickhouse@$(MAJOR)', true) }}
CMD_PREFIX ?= {{ CMD_PREFIX | default(d['SERVICE_CMD_PREFIX'], true) }}
START_CMD ?= {{ START_CMD | default('$(CMD_PREFIX) start $(SERVICE)', true) }}
STOP_CMD ?= {{ STOP_CMD | default('$(CMD_PREFIX) stop $(SERVICE)', true) }}
USER_XML ?= {{ USER_XML | default(d['CH_USER_XML'], true) }}
RENDER ?= {{ RENDER }}

# SUDO
SUDO_BIN ?= {{ SUDO_BIN | default(d['SUDO_BIN'], true) }}
SUDO_USER ?= {{ SUDO_USER | default(d['SUDO_USER'], true) }}
include $(DEVTOOLS_DIR)/templates/make/common/sudo.mk

.PHONY: install-ubuntu install-debian install-alpine install-macos install init-user start stop restart clean distclean init

install-ubuntu install-debian:
	$(SUDO) apt-get update
	$(SUDO) sudo apt-get install -y clickhouse-server clickhouse-client

install-alpine:
	$(SUDO) apk update --no-cache && $(SUDO) apk add clickhouse-server clickhouse-client

install-macos:
	brew install clickhouse-server clickhouse-client

install: install-$(OS)

init-user:
	$(SUDO) \
	ADMIN=$(ADMIN) ADMIN_PASSWORD=$(ADMIN_PASSWORD) \
		$(RENDER) --in=$(DEVTOOLS_DIR)/templates/make/user.xml --out=$(USER_XML)

init: init-user stop start

start:
	$(START_CMD)

stop:
	$(STOP_CMD)

restart: stop start

clean:

distclean:
