DEVTOOLS_DIR := {{ DEVTOOLS_DIR }}

include $(DEVTOOLS_DIR)/configure/defaults.mk
include $(DEVTOOLS_DIR)/templates/make/common/lib.mk

include {{ SETTINGS }}

ADMIN ?= {{ ADMIN | default('$(d__CH_ADMIN)', true) }}
ADMIN_PASSWORD ?= {{ ADMIN_PASSWORD | default('$(d__CH_ADMIN_PASSWORD)', true) }}
MAJOR ?= {{ MAJOR | default('23.5', true) }}
MINOR ?= {{ MINOR | default('', true) }}
OS ?= {{ OS | default('$(d__OS)', true) }}
OS_CODENAME ?= {{ OS_CODENAME | default('$(d__OS_CODENAME)', true) }}
SERVICE ?= {{ SERVICE | default('clickhouse@$(MAJOR)', true) }}
CMD_PREFIX ?= {{ CMD_PREFIX | default('$(d__SERVICE_CMD_PREFIX)', true) }}
START_CMD ?= {{ START_CMD | default('$(CMD_PREFIX) start $(SERVICE)', true) }}
STOP_CMD ?= {{ STOP_CMD | default('$(CMD_PREFIX) stop $(SERVICE)', true) }}
USER_XML ?= {{ USER_XML | default('$(d__CH_USER_XML)', true) }}

# SUDO
SUDO_BIN ?= {{ SUDO_BIN | default('$(d__SUDO_BIN)', true) }}
SUDO_USER ?= {{ SUDO_USER | default('$(d__SUDO_USER)', true) }}
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
	echo '<?xml version="1.0"?>'                                      > $(USER_XML)
	echo '<yandex>'                                                   >> $(USER_XML)
	echo '    <profiles>'                                             >> $(USER_XML)
	echo '        <default>'                                          >> $(USER_XML)
	echo '            <union_default_mode>ALL</union_default_mode>'   >> $(USER_XML)
	echo '        </default>'                                         >> $(USER_XML)
	echo '    </profiles>'                                            >> $(USER_XML)
	echo '    <users>'                                                >> $(USER_XML)
	echo '        <default>'                                          >> $(USER_XML)
	echo '            <access_management>1</access_management>'       >> $(USER_XML)
	echo '        </default>'                                         >> $(USER_XML)
	echo '        <$(ADMIN)>'                                         >> $(USER_XML)
	echo '            <password>$(ADMIN_PASSWORD)</password>'         >> $(USER_XML)
	echo '            <access_management>1</access_management>'       >> $(USER_XML)
	echo '        </$(ADMIN)>'                                        >> $(USER_XML)
	echo '</users>'                                                   >> $(USER_XML)
	echo '</yandex>'                                                  >> $(USER_XML)

init: init-user stop start

start:
	$(START_CMD)

stop:
	$(STOP_CMD)

restart: stop start

clean:

distclean:
