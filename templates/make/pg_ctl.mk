SELF := $(realpath $(lastword $(MAKEFILE_LIST)))
SELFDIR = $(realpath $(dir $(SELF)))
DEVTOOLS_DIR := {{ DEVTOOLS_DIR }}

include $(DEVTOOLS_DIR)/lib.mk

ADMIN ?= {{ ADMIN | default(d['PG_ADMIN'], true) }}
ADMIN_DB ?= {{ ADMIN_DB | default(d['PG_ADMIN_DB'], true) }}
ADMIN_PASSWORD ?= {{ ADMIN_PASSWORD | default(d['PG_ADMIN_PASSWORD'], true) }}
DATADIR ?= {{ DATADIR | default('$(SELFDIR)/pg_data', true) }}
HOST ?= {{ HOST | default(d['PG_HOST'], true) }}
INITDB_AUTH_HOST ?= {{ INITDB_AUTH_HOST | default('md5', true) }}
INITDB_AUTH_LOCAL ?= {{ INITDB_AUTH_LOCAL | default('peer', true) }}
INITDB_PWFILE ?= {{ INITDB_PWFILE | default('/tmp/passwd.tmp', true) }}
OS_USER ?= {{ OS_USER | default(d['PG_ADMIN'], true) }}
PG_CONFIG ?= {{ PG_CONFIG | default(d['PG_CONFIG'], true) }}
PG_CTL_CONF ?= {{ PG_CTL_CONF | default('$(DATADIR)/postgresql.conf', true) }}
PG_CTL_LOG ?= {{ PG_CTL_LOG | default('$(DATADIR)/pg_ctl.logs', true) }}
PG_CTL_LOGGING_COLLECTOR ?= {{ PG_CTL_LOGGING_COLLECTOR | default('on', true) }}
PORT ?= {{ PORT | default(d['PG_PORT'], true) }}

export LANG = {{ LANG | default(d['LOCALE_LANG'], true) }}
export LC_ALL = {{ LC_ALL | default(d['LOCALE_LC_ALL'], true) }}
export LC_CTYPE = {{ LC_CTYPE | default(d['LOCALE_LC_CTYPE'], true) }}

# SUDO
SUDO_BIN ?= {{ SUDO_BIN | default(d['SUDO_BIN'], true) }}
SUDO_USER = $(OS_USER)
include $(DEVTOOLS_DIR)/templates/make/common/sudo.mk

PG_BINDIR ?= $(shell $(PG_CONFIG) --bindir)
PG_CONF = $(DATADIR)/postgresql.conf
PG_CTL ?= $(PG_BINDIR)/pg_ctl
PG_INITDB ?= $(PG_BINDIR)/initdb
POSTMASTER = $(DATADIR)/postmaster.pid

CMD_INITDB ?= $(SUDO) $(PG_INITDB) \
        --pgdata=$(DATADIR) \
        --username=$(ADMIN) \
        --auth-local=$(INITDB_AUTH_LOCAL) \
        --auth-host=$(INITDB_AUTH_HOST) \
        --pwfile=$(INITDB_PWFILE)

CMD_START ?= $(SUDO) $(PG_CTL) -D $(DATADIR) -l $(PG_CTL_LOG) -o '\
        -k $(DATADIR) \
        -c logging_collector=$(PG_CTL_LOGGING_COLLECTOR) \
        -c config_file=$(PG_CTL_CONF) \
        -p $(PORT) -h $(HOST)' \
    start

CMD_STOP ?= $(SUDO) $(PG_CTL) -D $(DATADIR) -o '-k $(DATADIR) -c config_file=$(PG_CTL_CONF)' stop

# Targets
.PHONY: initdb start force-start stop clean distclean

$(PG_CONF):
	[ -d $(DATADIR) ] || mkdir -p $(DATADIR)
	$(SUDO_BIN) chown -R $(OS_USER) $(DATADIR)
	echo $(ADMIN_PASSWORD) > $(INITDB_PWFILE)
	$(CMD_INITDB)
	rm $(INITDB_PWFILE)

$(POSTMASTER):
	$(CMD_START)

initdb: $(PG_CONF)

start: initdb $(POSTMASTER)

force-start: initdb
	[ ! -f $(POSTMASTER) ] || rm -fv $(POSTMASTER)
	$(CMD_START)

stop:
	[ ! -f $(POSTMASTER) ] || $(CMD_STOP)

clean: stop 
	[ ! -d $(DATADIR) ] || rm -Rf $(DATADIR)

distclean: clean