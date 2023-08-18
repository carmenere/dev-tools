TOPDIR := {{ TOPDIR | default('$(shell pwd)', true) }}

ADMIN ?= {{ ADMIN | default('postgres', true)}}
ADMIN_DB ?= {{ ADMIN_DB | default('postgres', true)}}
ADMIN_PASSWORD ?= {{ ADMIN_PASSWORD | default('postgres', true)}}
ARTEFACTS_DIR ?= {{ ARTEFACTS_DIR | default('.artefacts', true) }}
DATADIR ?= {{ DATADIR | default('.artefacts/pg_data', true)}}
HOST ?= {{ HOST | default('localhost', true)}}
INITDB_AUTH_HOST ?= {{ INITDB_AUTH_HOST | default('md5', true)}}
INITDB_AUTH_LOCAL ?= {{ INITDB_AUTH_LOCAL | default('peer', true)}}
INITDB_PWFILE ?= {{ INITDB_PWFILE | default('/tmp/passwd.tmp', true)}}
OS_USER ?= {{ OS_USER | default('postgres', true)}}
PG_CONFIG ?= {{ PG_CONFIG | default('$(which pg_config)', true)}}
PG_CTL_CONF ?= {{ PG_CTL_CONF | default('$(DATADIR)/postgresql.conf', true)}}
PG_CTL_LOG ?= {{ PG_CTL_LOG | default('$(DATADIR)/pg_ctl.log', true)}}
PG_CTL_LOGGING_COLLECTOR ?= {{ PG_CTL_LOGGING_COLLECTOR | default('on', true)}}
PORT ?= {{ PORT | default('5432', true)}}
SUDO_BIN = {{ SUDO_BIN | default('$(shell which sudo)', true)}}
SUDO_USER = {{ SUDO_USER | default('postgres', true)}}

export LANG = {{ LANG | default('en_US.UTF-8', true)}}
export LC_ALL = {{ LC_ALL | default('en_US.UTF-8', true)}}
export LC_CTYPE = {{ LC_CTYPE | default('en_US.UTF-8', true)}}

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

PG_BINDIR ?= $(shell $(PG_CONFIG) --bindir)

PG_INITDB ?= $(PG_BINDIR)/initdb
PG_CTL ?= $(PG_BINDIR)/pg_ctl

CMD_INITDB ?= $(SUDO) \
    $(PG_INITDB) \
        --pgdata=$(DATADIR) \
        --username=$(ADMIN) \
        --auth-local=$(INITDB_AUTH_LOCAL) \
        --auth-host=$(INITDB_AUTH_HOST) \
        --pwfile=$(INITDB_PWFILE)

CMD_START ?= $(SUDO) \
    $(PG_CTL) -D $(DATADIR) -l $(PG_CTL_LOG) -o '\
        -k $(DATADIR) \
        -c logging_collector=$(PG_CTL_LOGGING_COLLECTOR) \
        -c config_file=$(PG_CTL_CONF) \
        -p $(PORT) -h $(HOST)' \
    start

CMD_STOP ?= $(SUDO) $(PG_CTL) -D $(DATADIR) -o '-k $(DATADIR) -c config_file=$(PG_CTL_CONF)' stop

# TMP Targets
TMP_ARTEFACTS_DIR ?= /tmp/$${USER}-pg-artefacts

# Targets
TGT_TMP_ARTEFACTS_DIR ?= $(TMP_ARTEFACTS_DIR)/create-tmp-artefacts-dir
TGT_ARTEFACTS_DIR ?= $(ARTEFACTS_DIR)/create-artefacts-dir
TGT_DATADIR ?= $(ARTEFACTS_DIR)/create-datadir
TGT_INITDB ?= $(ARTEFACTS_DIR)/initdb-$(ADMIN)-$(ADMIN_PASSWORD)-$(ADMIN_DB)-$(HOST)-$(PORT)
TGT_CREATE_ADMIN ?= $(ARTEFACTS_DIR)/create-super-user-$(ADMIN)-$(ADMIN_PASSWORD)
TGT_START ?= $(TMP_ARTEFACTS_DIR)/start

.PHONY: init initdb check-user check-superuser create-user create-db connect drop clean clear-db clean-user-artefacts start stop distclean migrate migrate-revert

$(TGT_ARTEFACTS_DIR):
	mkdir -p $(ARTEFACTS_DIR)
	touch $@

$(TGT_TMP_ARTEFACTS_DIR):
	mkdir -p $(TMP_ARTEFACTS_DIR)
	touch $@

$(TGT_DATADIR): $(TGT_ARTEFACTS_DIR)
	mkdir -p $(DATADIR)
	touch $@

$(TGT_INITDB): $(TGT_ARTEFACTS_DIR) $(TGT_DATADIR)
	$(SUDO) chown $(OS_USER) $(DATADIR)
	[ -f $(TGT_INITDB) ] || echo $(ADMIN_PASSWORD) > $(INITDB_PWFILE)
	[ -f $(TGT_INITDB) ] || $(CMD_INITDB)
	[ -f $(TGT_INITDB) ] || rm $(INITDB_PWFILE)
	[ -f $(TGT_INITDB) ] || touch $@
	[ -f $(TGT_CREATE_ADMIN) ] || touch $(TGT_CREATE_ADMIN)

$(TGT_START): $(TGT_TMP_ARTEFACTS_DIR)
	$(eval START ?= $(shell ! test -f $(TGT_START) && test -f $(TGT_INITDB) && echo 'yes' || ''))
	[ -z "$(START)" ] || $(CMD_START)
	[ -z "$(START)" ] || touch $@

initdb: $(TGT_INITDB)

start: $(TGT_INITDB) $(TGT_START)

stop: $(TGT_DATADIR)
	[ ! -f "$(TGT_START)" ] || $(CMD_STOP)
	[ ! -f "$(TGT_START)" ] || rm $(TGT_START)

clean: stop 
	[ ! -d $(DATADIR) ] || $(SUDO) rm -Rf $(DATADIR)
	[ ! -d $(ARTEFACTS_DIR) ] || rm -Rfv $(ARTEFACTS_DIR)
	[ ! -d $(TMP_ARTEFACTS_DIR) ] || rm -Rfv $(TMP_ARTEFACTS_DIR)

force-clean: 
	[ ! -d $(DATADIR) ] || $(SUDO) rm -Rf $(DATADIR)
	[ ! -d $(ARTEFACTS_DIR) ] || rm -Rfv $(ARTEFACTS_DIR)
	[ ! -d $(TMP_ARTEFACTS_DIR) ] || rm -Rfv $(TMP_ARTEFACTS_DIR)

init: $(TGT_CREATE_USER) $(TGT_CREATE_DB) $(TGT_GRANT)

distclean: clean
	[ ! -d $(ARTEFACTS_DIR) ] || rm -Rf $(ARTEFACTS_DIR)
	[ ! -d $(TMP_ARTEFACTS_DIR) ] || rm -Rf $(TMP_ARTEFACTS_DIR)
