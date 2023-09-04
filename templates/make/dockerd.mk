DEVTOOLS_DIR := {{ DEVTOOLS_DIR }}
SETTINGS := {{ SETTINGS }}

include $(DEVTOOLS_DIR)/configure/defaults.mk
include $(DEVTOOLS_DIR)/templates/make/common/lib.mk

ifdef SETTINGS
    include $(SETTINGS)
endif

OS ?= {{ OS | default('$(OS)', true) }}
OS_CODENAME ?= {{ OS_CODENAME | default('$(OS_CODENAME)', true) }}
SERVICE ?= {{ SERVICE | default('docker', true) }}
CMD_PREFIX ?= {{ CMD_PREFIX | default('$(SERVICE_CMD_PREFIX)', true) }}
START_CMD ?= {{ START_CMD | default('$(CMD_PREFIX) start $(SERVICE)', true) }}
STOP_CMD ?= {{ STOP_CMD | default('$(CMD_PREFIX) stop $(SERVICE)', true) }}

# SUDO
include $(DEVTOOLS_DIR)/templates/make/common/sudo.mk

.PHONY: install-ubuntu install-debian install-alpine install-macos install init-user start stop restart clean distclean init

install-ubuntu install-debian:
	$(SUDO) apt-get update
	$(SUDO) apt-get install ca-certificates curl gnupg
	$(SUDO) install -m 0755 -d /etc/apt/keyrings
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | $(SUDO) gpg --dearmor -o /etc/apt/keyrings/docker.gpg
	$(SUDO) chmod a+r /etc/apt/keyrings/docker.gpg
	echo \
		"deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
		"$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
		$(SUDO) tee /etc/apt/sources.list.d/docker.list > /dev/null
	$(SUDO) apt-get update
	$(SUDO) apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

install-alpine:
	$(SUDO) apk update --no-cache && $(SUDO) apk add docker docker-cli-compose

install-macos:
# Got to https://docs.docker.com/desktop/install/mac-install/ and follow instructions.

install: install-$(OS) post-install

post-install:
	$(SUDO) usermod -aG docker $(USER)

start:
	$(START_CMD)

stop:
	$(STOP_CMD)

restart: stop start

clean:

distclean: