DEVTOOLS_DIR := {{ DEVTOOLS_DIR }}

include $(DEVTOOLS_DIR)/lib.mk

MAJOR ?= {{ MAJOR }}
MINOR ?= {{ MINOR }}
OS ?= {{ OS }}
SERVICE ?= {{ SERVICE }}
CMD_PREFIX ?= {{ CMD_PREFIX }}
START_CMD ?= {{ START_CMD }}
STOP_CMD ?= {{ STOP_CMD }}

# SUDO
SUDO_BIN ?= {{ SUDO_BIN }}
SUDO_USER ?= {{ SUDO_USER }}
include $(DEVTOOLS_DIR)/templates/common/sudo.mk

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
