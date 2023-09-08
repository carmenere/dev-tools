DEVTOOLS_DIR := {{ DEVTOOLS_DIR }}

include $(DEVTOOLS_DIR)/lib.mk

AUTH_POLICY ?= {{ AUTH_POLICY | default('host  all  all  0.0.0.0/0  md5', true) }}
MAJOR ?= {{ MAJOR | default('12', true) }}
MINOR ?= {{ MINOR | default('15_2', true) }}
OS ?= {{ OS | default(d['OS'], true) }}
PG_HBA ?= {{ PG_HBA | default('/opt/homebrew/var/$(SERVICE)/pg_hba.conf', true) }}
SERVICE ?= {{ SERVICE | default('postgresql@$(MAJOR)', true) }}
CMD_PREFIX ?= {{ CMD_PREFIX | default(d['SERVICE_CMD_PREFIX'], true) }}
START_CMD ?= {{ START_CMD | default('$(CMD_PREFIX) start $(SERVICE)', true) }}
STOP_CMD ?= {{ STOP_CMD | default('$(CMD_PREFIX) stop $(SERVICE)', true) }}

# SUDO
SUDO_BIN ?= {{ SUDO_BIN | default(d['SUDO_BIN'], true) }}
SUDO_USER ?= {{ SUDO_USER | default(d['SUDO_USER'], true) }}
include $(DEVTOOLS_DIR)/templates/common/sudo.mk

.PHONY: install-ubuntu install-debian install-alpine install-macos install add-auth-policy start stop restart clean distclean

install-ubuntu install-debian:
	$(SUDO) sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $$(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
	$(SUDO) wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | $(SUDO) apt-key add -
	$(SUDO) apt-get update
	$(SUDO) apt-get -y install \
		postgresql-$(MAJOR) \
		postgresql-contrib \
		postgresql-server-dev-$(MAJOR) \
		libpq-dev

install-alpine:
	$(SUDO) apk update --no-cache && $(SUDO) apk add \
		postgresql$(MAJOR) \
		postgresql$(MAJOR)-contrib \
		postgresql$(MAJOR)-dev

install-macos:
	brew install $(SERVICE)

install: install-$(OS)

add-auth-policy:
	grep -qxF '$(AUTH_POLICY)' $(PG_HBA) || echo "$(AUTH_POLICY)" | $(SUDO) tee -a $(PG_HBA)

start:
	$(START_CMD)

stop:
	$(STOP_CMD)

restart: stop start

clean:

distclean:
