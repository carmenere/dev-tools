DEVTOOLS_DIR := {{ DEVTOOLS_DIR }}

include $(DEVTOOLS_DIR)/lib.mk

ADMIN ?= {{ ADMIN }}
ADMIN_PASSWORD ?= {{ ADMIN_PASSWORD }}
MAJOR ?= {{ MAJOR }}
MINOR ?= {{ MINOR }}
OS ?= {{ OS }}
SERVICE ?= {{ SERVICE }}
CMD_PREFIX ?= {{ CMD_PREFIX }}
START_CMD ?= {{ START_CMD }}
STOP_CMD ?= {{ STOP_CMD }}
USER_XML ?= {{ USER_XML }}
RENDER ?= {{ RENDER }}

# SUDO
SUDO_BIN ?= {{ SUDO_BIN }}
SUDO_USER ?= {{ SUDO_USER }}
include $(DEVTOOLS_DIR)/templates/common/sudo.mk

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
