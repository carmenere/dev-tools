LIB := {{ LIB }}
include $(LIB)/common.mk

ADMIN ?= {{ ADMIN }}
ADMIN_DB ?= {{ ADMIN_DB }}
ADMIN_PASSWORD ?= {{ ADMIN_PASSWORD }}
AUTH_METHOD ?= {{ AUTH_METHOD }}
CNT = {{ CNT }}
EXIT_IF_CREATE_EXISTED_DB = {{ EXIT_IF_CREATE_EXISTED_DB }}
EXIT_IF_CREATE_EXISTED_USER = {{ EXIT_IF_CREATE_EXISTED_USER }}
HOST ?= {{ HOST }}
PORT ?= {{ PORT }}
SUDO_BIN = {{ SUDO_BIN }}
SUDO_USER = {{ SUDO_USER }}
USER_ATTRIBUTES ?= {{ USER_ATTRIBUTES }}
USER_DB ?= {{ USER_DB }}
USER_NAME ?= {{ USER_NAME }}
USER_PASSWORD ?= {{ USER_PASSWORD }}

CONN_URL ?= postgresql://$(ADMIN):$(ADMIN_PASSWORD)@$(HOST):$(PORT)/$(ADMIN_DB)
USER_CONN_URL ?= postgresql://$(USER_NAME):$(USER_PASSWORD)@$(HOST):$(PORT)/$(USER_DB)

define select_user
SELECT '$1' FROM pg_roles WHERE rolname = '$1'
endef

define select_db
SELECT '$1' FROM pg_database WHERE datname = '$1'
endef

define check
$$($(PSQL) -tXAc $$'$(subst ',\',$(call select_$1,$2))')
endef

ATTRIBUTES ?= 
PATH_TO_DUMP ?= 

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

#
ifdef CNT
    PSQL ?= docker exec $(TI) $(CNT) psql -U $(ADMIN) -d $(ADMIN_DB)
    PSQL_USER ?= docker exec $(TI) $(CNT) psql -U $(USER_NAME) -d $(USER_DB)
else ifeq ($(AUTH_METHOD),remote)
    PSQL = psql $(CONN_URL)
    PSQL_USER ?= psql $(USER_CONN_URL)
else ifeq ($(AUTH_METHOD),peer)
    PSQL ?= $(SUDO) -iu $(ADMIN) PGDATABASE=$(ADMIN_DB) psql
    PSQL_USER ?= $(SUDO) -iu $(USER_NAME) PGDATABASE=$(USER_DB) psql
else
    $(error Unsupported value '$(AUTH_METHOD)' for 'AUTH_METHOD' variable. SECTION=$(SECTION))
endif

# Targets

.PHONY: init create-user create-db grant revoke connect connect-admin clear clean dump distclean import

create-user:
	if [[ "$(EXIT_IF_CREATE_EXISTED_USER)" == yes && -n "$(call check,user,$(USER_NAME))" ]]; then false; fi
	[ -n "$(call check,user,$(USER_NAME))" ] || $(PSQL) -c "CREATE USER $(USER_NAME) WITH ENCRYPTED PASSWORD '$(USER_PASSWORD)' $(USER_ATTRIBUTES);"

create-db: create-user
	if [[ "$(EXIT_IF_CREATE_EXISTED_DB)" == yes && -n "$(call check,db,$(USER_DB))" ]]; then false; fi
	[ -n "$(call check,db,$(USER_DB))" ] || $(PSQL) -c "CREATE DATABASE $(USER_DB) WITH OWNER=$(USER_NAME);"

grant: create-db
	# Assign priviliges to user '$(USER_NAME)'
	$(PSQL) -c "GRANT ALL PRIVILEGES ON DATABASE $(USER_DB) TO $(USER_NAME);"
	$(PSQL) -c "GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO $(USER_NAME);"

revoke:
	$(foreach A,$(ATTRIBUTES),$(PSQL) -c "ALTER USER $(USER_NAME) WITH NO$(ATTRIBUTE);" $(LF))

init: create-user create-db grant

connect: override TI = -ti
connect:
	$(PSQL_USER)

connect-admin: override TI = -ti
connect-admin:
	$(PSQL)

clear:
	$(PSQL_USER) -c "DROP SCHEMA IF EXISTS public CASCADE;"
	$(PSQL_USER) -c "CREATE schema public;"

clean:
	$(PSQL) -c "DROP DATABASE IF EXISTS $(USER_DB);"
	$(PSQL) -c "DROP USER IF EXISTS $(USER_NAME);"

dump:
	PGPASSWORD=$(USER_PASSWORD) pg_dump -h $(HOST) -p $(PORT) -U $(USER_NAME) -d $(USER_DB) --file=$(PATH_TO_DUMP)

distclean: clean

import: clean init
	$(USER_URL) --set ON_ERROR_STOP=on -f "$(PATH_TO_DUMP)"
