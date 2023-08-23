TOPDIR := {{ TOPDIR }}

AUTH_POLICY ?= {{ AUTH_POLICY }}
MAJOR ?= {{ MAJOR }}
MINOR ?= {{ MINOR }}
OS ?= {{ OS }}
OS_CODENAME ?= {{ OS_CODENAME }}
PG_HBA ?= {{ PG_HBA }}
REMOTE_PREFIX ?= {{ REMOTE_PREFIX }}
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

install-ubuntu install-debian:
	sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(OS_CODENAME)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
	wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
	apt-get update
	apt-get -y install \
		postgresql-$(MAJOR) \
		postgresql-contrib \
		postgresql-server-dev-$(MAJOR) \
		libpq-dev

install: install-$(OS)

add-auth-policy:
	grep -qxF '$(AUTH_POLICY)' $(PG_HBA) || echo "$(AUTH_POLICY)" | $(SUDO) tee -a $(PG_HBA)
