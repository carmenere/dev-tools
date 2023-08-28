MAJOR ?= {{ MAJOR }}
MINOR ?= {{ MINOR }}
OS ?= {{ OS }}
OS_CODENAME ?= {{ OS_CODENAME }}
SERVICE ?= {{ SERVICE }}
START_CMD ?= {{ START_CMD }}
STOP_CMD ?= {{ STOP_CMD }}
SUDO_BIN ?= {{ SUDO_BIN }}
SUDO_USER ?= {{ SUDO_USER }}
VERSION ?= {{ VERSION }}

# $(and ..., ..., ...) 
# - each argument is expanded, in order;
# - if an argument expands to an empty string the processing stops and the result of the expansion is the empty string;
# - if all arguments expand to a non-empty string then the result of the expansion is the expansion of the last argument;
ifneq ($(strip $(and $(SUDO_BIN),$(SUDO_USER))),)
    SUDO = $(SUDO_BIN) -u $(SUDO_USER)
else ifneq ($(strip $(SUDO_BIN)),)
    SUDO = $(SUDO_BIN)
else
    SUDO = 
endif

.PHONY: install-ubuntu install-debian install-alpine install-macos install start stop restart

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