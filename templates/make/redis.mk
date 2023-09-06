DEVTOOLS_DIR := {{ DEVTOOLS_DIR }}

include $(DEVTOOLS_DIR)/lib.mk

MAJOR ?= {{ MAJOR | default('7', true) }}
MINOR ?= {{ MINOR | default('0.1', true) }}
OS ?= {{ OS | default(d['OS'], true) }}
SERVICE ?= {{ SERVICE | default('redis', true) }}
CMD_PREFIX ?= {{ CMD_PREFIX | default(d['SERVICE_CMD_PREFIX'], true) }}
START_CMD ?= {{ START_CMD | default('$(CMD_PREFIX) start $(SERVICE)', true) }}
STOP_CMD ?= {{ STOP_CMD | default('$(CMD_PREFIX) stop $(SERVICE)', true) }}
VERSION ?= {{ VERSION | default('$(MAJOR).$(MINOR)', true) }}

# SUDO
SUDO_BIN ?= {{ SUDO_BIN | default(d['SUDO_BIN'], true) }}
SUDO_USER ?= {{ SUDO_USER | default(d['SUDO_USER'], true) }}
include $(DEVTOOLS_DIR)/templates/make/common/sudo.mk

.PHONY: install-ubuntu install-debian install-alpine install-macos install start stop restart clean distclean

install-ubuntu install-debian:
	$(SUDO) apt-get update
	$(SUDO) apt-get -y install redis

install-alpine:
	$(SUDO) apk update --no-cache && $(SUDO) apk add redis

install-macos:
	brew install redis@$(MAJOR)

install: install-$(OS)

start:
	$(START_CMD)

stop:
	$(STOP_CMD)

restart: stop start

clean:

distclean:
