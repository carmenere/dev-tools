TOPDIR := {{ TOPDIR | default('$(shell pwd)', true) }}

ATTRIBUTE ?= 
PATH_TO_DUMP ?= 

ARTEFACTS_DIR ?= {{ ARTEFACTS_DIR | default('.artefacts', true) }}
AUTH_METHOD ?= {{ AUTH_METHOD | default('remote', true) }}
HOST ?= {{ HOST | default('localhost', true) }}
PGDATABASE ?= {{ PGDATABASE | default('postgres', true) }}
PGPASSWORD ?= {{ PGPASSWORD | default('postgres', true) }}
PGUSER ?= {{ PGUSER | default('postgres', true) }}
PORT ?= {{ PORT | default('5432', true) }}
USER_NAME ?= {{ USER_NAME | default('foo', true) }}
USER_DB ?= {{ USER_DB | default('bar', true) }}
USER_PASSWORD ?= {{ USER_PASSWORD | default('12345', true) }}
USER_ATTRIBUTES ?= {{ USER_ATTRIBUTES | default('SUPERUSER CREATEDB', true) }}
CONTAINER = {{ CONTAINER | default('', true)}}
MODE = {{ MODE | default('host', true)}}
SUDO_BIN = {{ SUDO_BIN | default('$(shell which sudo)', true)}}
SUDO_USER = {{ SUDO_USER | default('', true)}}

ifeq ($(AUTH_METHOD),remote)
    PSQL_ADMIN ?= $(DOCKER_EXEC) psql postgresql://$(PGUSER):$(PGPASSWORD)@$(HOST):$(PORT)/$(PGDATABASE)
    PSQL ?= $(DOCKER_EXEC) psql postgresql://$(USER_NAME):$(USER_PASSWORD)@$(HOST):$(PORT)/$(USER_DB)
else ifeq ($(AUTH_METHOD),peer)
    PSQL_ADMIN ?= $(DOCKER_EXEC) $(SUDO) -iu $(PGUSER) PGDATABASE=$(PGDATABASE) psql
    PSQL ?= $(DOCKER_EXEC) $(SUDO) -iu $(USER_NAME) PGDATABASE=$(USER_DB) psql
else
    $(error Unsupported value '$(AUTH_METHOD)' for 'AUTH_METHOD' variable. SECTION=$(SECTION))
endif

ifeq ($(strip $(MODE)$(CONTAINER)),docker)
    $(error For MODE=docker var CONTAINER must be defined!)
endif

ifeq ($(strip $(MODE)),docker)
    DOCKER_EXEC = docker exec $(TI) $(CONTAINER)
else ifeq ($(MODE),host)
    DOCKER_EXEC = 
else
    $(error Unknown value '$(MODE)' for var 'MODE'.)
endif

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

# Targets
TGT_TMP_ARTEFACTS_DIR ?= $(TMP_ARTEFACTS_DIR)/.create-tmp-artefacts-dir
TGT_ARTEFACTS_DIR ?= $(ARTEFACTS_DIR)/.create-artefacts-dir
TGT_CREATE_USER ?= $(ARTEFACTS_DIR)/.$(MODE)-create-user-$(USER_NAME)-$(USER_PASSWORD)
TGT_CREATE_DB ?= $(ARTEFACTS_DIR)/.$(MODE)-create-db-$(USER_DB)
TGT_GRANT ?= $(ARTEFACTS_DIR)/.$(MODE)-grant-$(USER_NAME)-$(USER_DB)

.PHONY: init check-user check-superuser create-user create-db connect drop force-drop clean-artefacts clean force-clean clear-db distclean dump

$(TGT_ARTEFACTS_DIR):
	mkdir -p $(ARTEFACTS_DIR)
	touch $@

check-superuser:
	$(PSQL_ADMIN) -c "SELECT 1;" 2>&1 | grep 'psql: error:' && exit 1 || true

check-user:
	$(PSQL) -c "SELECT 1;" 2>&1 | grep 'psql: error:' && exit 1 || true

$(TGT_CREATE_USER): $(TGT_ARTEFACTS_DIR)
	[ -f $(TGT_CREATE_USER) ] || $(PSQL_ADMIN) -c "CREATE USER $(USER_NAME) WITH ENCRYPTED PASSWORD '$(USER_PASSWORD)' $(USER_ATTRIBUTES);"
	[ -f $(TGT_CREATE_USER) ] || touch $@

$(TGT_CREATE_DB): $(TGT_CREATE_USER)
	[ -f $(TGT_CREATE_DB) ] || $(PSQL_ADMIN) -c "CREATE DATABASE $(USER_DB) WITH OWNER=$(USER_NAME);"
	[ -f $(TGT_CREATE_DB) ] || touch $@

$(TGT_GRANT): $(TGT_CREATE_DB)
	# Assign priviliges to user '$(USER_NAME)'
	[ -f $(TGT_GRANT) ] || $(PSQL_ADMIN) -c "GRANT ALL PRIVILEGES ON DATABASE $(USER_DB) TO $(USER_NAME);"
	[ -f $(TGT_GRANT) ] || $(PSQL_ADMIN) -c "GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO $(USER_NAME);"
	[ -f $(TGT_GRANT) ] || touch $@


init: $(TGT_CREATE_USER) $(TGT_CREATE_DB) $(TGT_GRANT)

connect: override TI = -ti
connect:
	$(PSQL)

connect: override TI = -ti
connect-admin:
	$(PSQL_ADMIN)

clear-db:
	$(eval CLEAR_DB ?= $(shell test -f $(TGT_CREATE_DB) && test -f $(TGT_CREATE_USER) && echo 'yes' || ''))
	[ -z "$(CLEAR_DB)" ] || $(PSQL) -c "DROP SCHEMA public CASCADE;"
	[ -z "$(CLEAR_DB)" ] || $(PSQL) -c "CREATE schema public;"

drop:
	[ ! -f $(TGT_CREATE_DB) ] || $(PSQL_ADMIN) -c "DROP DATABASE IF EXISTS $(USER_DB);"
	[ ! -f $(TGT_CREATE_USER) ] || $(PSQL_ADMIN) -c "DROP USER IF EXISTS $(USER_NAME);"

force-drop:
	$(PSQL_ADMIN) -c "DROP DATABASE IF EXISTS $(USER_DB);"
	$(PSQL_ADMIN) -c "DROP USER IF EXISTS $(USER_NAME);"

clean-artefacts:
	[ ! -f $(TGT_CREATE_USER) ] || rm -fv $(TGT_CREATE_USER)
	[ ! -f $(TGT_CREATE_DB) ] || rm -fv $(TGT_CREATE_DB)
	[ ! -f $(TGT_GRANT) ] || rm -fv $(TGT_GRANT)

clean: drop clean-artefacts

force-clean: force-drop clean-artefacts

dump:
	PGPASSWORD=$(USER_PASSWORD) pg_dump -h $(HOST) -p $(PORT) -U $(USER_NAME) -d $(USER_DB) --file=$(PATH_TO_DUMP)

distclean: clean
	[ ! -d $(ARTEFACTS_DIR) ] || rm -Rf $(ARTEFACTS_DIR)

import: clean init
	$(PSQL) --set ON_ERROR_STOP=on -f "$(PATH_TO_DUMP)"

revoke-attribute:
ifdef ATTRIBUTE
	[ -f $(TGT_CREATE_USER) ] || $(PSQL_ADMIN) -c "ALTER USER $(USER_NAME) WITH NO$(ATTRIBUTE);"
endif
