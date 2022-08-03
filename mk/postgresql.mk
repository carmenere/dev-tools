# Includes
include $(ARTEFACTS)/.env.postgresql

### Targets
.PHONY: default env init strip fmt lint unit-tests runcargo build clean clean-makefile clean-autotools distclean \
	init migrate migrate-revert clear-db clean check-user check-superuser

default: env

env:
	@echo $(foreach e,$(ENVs),export $(e)=\'$($(e))\'"\n") export ENVs=\'$(ENVs)\'"\n"

$(TARGET_INIT_DIR):
	mkdir -p $(POSTGRES_ARTEFACTS_DIR)
	touch $@

init: $(TARGET_INIT_DIR)

check-superuser:
	$(PSQL_SUPERUSER) -c "SELECT 1;" 2>&1 | grep 'psql: error:' && exit 1 || true

check-user:
	$(PSQL) -c "SELECT 1;" 2>&1 | grep 'psql: error:' && exit 1 || true

$(TARGET_INIT_ROLE):
	$(MAKE) -f $(MK)/postgresql.mk check-superuser
	# Create new user '$(POSTGRES_USER)'
	$(PSQL_SUPERUSER) -c "CREATE USER $(POSTGRES_USER) WITH ENCRYPTED PASSWORD '$(POSTGRES_USER_PASSWORD)' SUPERUSER CREATEDB;"

	# Create new database '$(POSTGRES_USER_DB)'
	$(PSQL_SUPERUSER) -c "CREATE DATABASE $(POSTGRES_USER_DB) WITH OWNER=$(POSTGRES_USER);"

	# Assign priviliges to user '$(POSTGRES_USER)'
	$(PSQL_SUPERUSER) -c "GRANT ALL PRIVILEGES ON DATABASE $(POSTGRES_USER_DB) TO $(POSTGRES_USER);"

	$(MAKE) -f $(MK)/postgresql.mk check-user
	touch $@

init: $(TARGET_INIT_ROLE)

connect:
	$(PSQL)

clear-db: check-superuser
	$(PSQL_SUPERUSER) -c "DROP DATABASE IF EXISTS $(POSTGRES_USER_DB)_tmpdb"
	$(PSQL_SUPERUSER) -c "CREATE DATABASE $(POSTGRES_USER_DB)_tmpdb WITH OWNER=$(POSTGRES_USER);"
	$(PSQL_SUPERUSER) -d $(POSTGRES_USER_DB)_tmpdb -c "DROP DATABASE IF EXISTS $(POSTGRES_USER_DB);"
	$(PSQL_SUPERUSER) -d $(POSTGRES_USER_DB)_tmpdb -c "CREATE DATABASE $(POSTGRES_USER_DB) WITH OWNER=$(POSTGRES_USER);"
	$(PSQL_SUPERUSER) -d $(POSTGRES_USER_DB) -c "DROP DATABASE IF EXISTS $(POSTGRES_USER_DB)_tmpdb;"

clean: check-superuser
	$(PSQL_SUPERUSER) -c "drop database if exists $(POSTGRES_USER_DB);"
	$(PSQL_SUPERUSER) -c "drop user if exists $(POSTGRES_USER);"
	[ ! -d $(POSTGRES_ARTEFACTS_DIR) ] || rm -Rfv $(POSTGRES_ARTEFACTS_DIR)
