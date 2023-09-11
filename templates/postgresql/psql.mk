DEVTOOLS_DIR := {{ DEVTOOLS_DIR }}

include $(DEVTOOLS_DIR)/lib.mk

ADMIN ?= {{ ADMIN }}
ADMIN_DB ?= {{ ADMIN_DB }}
ADMIN_PASSWORD ?= {{ ADMIN_PASSWORD }}
AUTH_METHOD ?= {{ AUTH_METHOD }}
CNT = {{ CNT }}
EXIT_IF_DB_EXISTS = {{ EXIT_IF_DB_EXISTS }}
EXIT_IF_USER_EXISTS = {{ EXIT_IF_USER_EXISTS }}
HOST ?= {{ HOST }}
PORT ?= {{ PORT }}
USER_ATTRIBUTES ?= {{ USER_ATTRIBUTES }}
USER_DB ?= {{ USER_DB }}
USER_NAME ?= {{ USER_NAME }}
USER_PASSWORD ?= {{ USER_PASSWORD }}

CONN_URL ?= {{ CONN_URL }}
USER_CONN_URL ?= {{ USER_CONN_URL }}
 

# SUDO
SUDO_BIN ?= {{ SUDO_BIN }}
SUDO_USER ?= {{ SUDO_USER }}
include $(DEVTOOLS_DIR)/templates/common/sudo.mk

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
ifeq ($(EXIT_IF_USER_EXISTS),yes)
	[ -z "$(call check,user,$(USER_NAME))" ] || false
endif
	[ -n "$(call check,user,$(USER_NAME))" ] || $(PSQL) -c "CREATE USER $(USER_NAME) WITH ENCRYPTED PASSWORD '$(USER_PASSWORD)' $(USER_ATTRIBUTES);"

create-db: create-user
ifeq ($(EXIT_IF_DB_EXISTS),yes)
	[ -z "$(call check,db,$(USER_DB))" ] || false
endif
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

dump:
	PGPASSWORD=$(USER_PASSWORD) pg_dump -h $(HOST) -p $(PORT) -U $(USER_NAME) -d $(USER_DB) --file=$(PATH_TO_DUMP)

import: clean init
	$(USER_URL) --set ON_ERROR_STOP=on -f "$(PATH_TO_DUMP)"

clear:
	$(PSQL_USER) -c "DROP SCHEMA IF EXISTS public CASCADE;"
	$(PSQL_USER) -c "CREATE schema public;"

clean:
	$(PSQL) -c "DROP DATABASE IF EXISTS $(USER_DB);"
	$(PSQL) -c "DROP USER IF EXISTS $(USER_NAME);"

distclean: clean

include $(DEVTOOLS_DIR)/templates/common/lsof.mk
