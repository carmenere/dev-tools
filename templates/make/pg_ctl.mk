SELFDIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))

DEVTOOLS_DIR := {{ DEVTOOLS_DIR }}

include $(DEVTOOLS_DIR)/configure/defaults.mk
include $(DEVTOOLS_DIR)/templates/make/common/lib.mk

include {{ SETTINGS }}

ADMIN ?= {{ ADMIN | default('$(d__PG_ADMIN)', true) }}
ADMIN_DB ?= {{ ADMIN_DB | default('$(d__PG_ADMIN_DB)', true) }}
ADMIN_PASSWORD ?= {{ ADMIN_PASSWORD | default('$(d__PG_ADMIN_PASSWORD)', true) }}
DATADIR ?= {{ DATADIR | default('$(SELFDIR)/pg_data', true) }}
HOST ?= {{ HOST | default('$(d__PG_HOST)', true) }}
INITDB_AUTH_HOST ?= {{ INITDB_AUTH_HOST | default('md5', true) }}
INITDB_AUTH_LOCAL ?= {{ INITDB_AUTH_LOCAL | default('peer', true) }}
INITDB_PWFILE ?= {{ INITDB_PWFILE | default('/tmp/passwd.tmp', true) }}
OS_USER ?= {{ OS_USER | default('$(d__PG_ADMIN)', true) }}
PG_CONFIG ?= {{ PG_CONFIG | default('$(d__PG_CONFIG)', true) }}
PG_CTL_CONF ?= {{ PG_CTL_CONF | default('$(DATADIR)/postgresql.conf', true) }}
PG_CTL_LOG ?= {{ PG_CTL_LOG | default('$(DATADIR)/pg_ctl.logs', true) }}
PG_CTL_LOGGING_COLLECTOR ?= {{ PG_CTL_LOGGING_COLLECTOR | default('on', true) }}
PORT ?= {{ PORT | default('$(d__PG_PORT)', true) }}

export LANG = {{ LANG | default('$(d__LOCALE_LANG)', true) }}
export LC_ALL = {{ LC_ALL | default('$(d__LOCALE_LC_ALL)', true) }}
export LC_CTYPE = {{ LC_CTYPE | default('$(d__LOCALE_LC_CTYPE)', true) }}

PG_BINDIR ?= $(shell $(PG_CONFIG) --bindir)
PG_CONF = $(DATADIR)/postgresql.conf
PG_CTL ?= $(PG_BINDIR)/pg_ctl
PG_INITDB ?= $(PG_BINDIR)/initdb
POSTMASTER = $(DATADIR)/postmaster.pid

CMD_INITDB ?= $(PG_INITDB) \
        --pgdata=$(DATADIR) \
        --username=$(ADMIN) \
        --auth-local=$(INITDB_AUTH_LOCAL) \
        --auth-host=$(INITDB_AUTH_HOST) \
        --pwfile=$(INITDB_PWFILE)

CMD_START ?= $(PG_CTL) -D $(DATADIR) -l $(PG_CTL_LOG) -o '\
        -k $(DATADIR) \
        -c logging_collector=$(PG_CTL_LOGGING_COLLECTOR) \
        -c config_file=$(PG_CTL_CONF) \
        -p $(PORT) -h $(HOST)' \
    start

CMD_STOP ?= $(PG_CTL) -D $(DATADIR) -o '-k $(DATADIR) -c config_file=$(PG_CTL_CONF)' stop

# Targets
.PHONY: initdb start force-start stop clean distclean

$(PG_CONF):
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