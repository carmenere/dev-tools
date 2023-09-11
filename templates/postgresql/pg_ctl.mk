SELF := $(realpath $(lastword $(MAKEFILE_LIST)))
SELFDIR = $(realpath $(dir $(SELF)))
DEVTOOLS_DIR := {{ DEVTOOLS_DIR }}

include $(DEVTOOLS_DIR)/lib.mk

ADMIN ?= {{ ADMIN }}
ADMIN_DB ?= {{ ADMIN_DB }}
ADMIN_PASSWORD ?= {{ ADMIN_PASSWORD }}
DATADIR ?= {{ DATADIR }}
HOST ?= {{ HOST }}
INITDB_AUTH_HOST ?= {{ INITDB_AUTH_HOST }}
INITDB_AUTH_LOCAL ?= {{ INITDB_AUTH_LOCAL }}
INITDB_PWFILE ?= {{ INITDB_PWFILE }}
OS_USER ?= {{ OS_USER }}
PG_CONFIG ?= {{ PG_CONFIG }}
PG_CTL_CONF ?= {{ PG_CTL_CONF }}
PG_CTL_LOG ?= {{ PG_CTL_LOG }}
PG_CTL_LOGGING_COLLECTOR ?= {{ PG_CTL_LOGGING_COLLECTOR }}
PORT ?= {{ PORT }}

export LANG = {{ LANG }}
export LC_ALL = {{ LC_ALL }}
export LC_CTYPE = {{ LC_CTYPE }}

# SUDO
SUDO_BIN ?= {{ SUDO_BIN }}
SUDO_USER = $(OS_USER)
include $(DEVTOOLS_DIR)/templates/common/sudo.mk

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

include $(DEVTOOLS_DIR)/templates/common/lsof.mk