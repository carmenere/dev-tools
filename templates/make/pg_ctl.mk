TOPDIR := $(shell pwd)

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
SUDO_BIN = {{ SUDO_BIN }}
SUDO_USER = {{ SUDO_USER }}

export LANG = {{ LANG }}
export LC_ALL = {{ LC_ALL }}
export LC_CTYPE = {{ LC_CTYPE }}

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
.PHONY: initdb start force-start

$(PG_CONF):
	echo $(ADMIN_PASSWORD) > $(INITDB_PWFILE)
	$(CMD_INITDB)
	rm $(INITDB_PWFILE)
	touch $@

$(POSTMASTER):
	$(CMD_START)
	touch $@

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
