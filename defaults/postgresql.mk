# server
postgresql__AUTH_POLICY ?= host  all  all  0.0.0.0/0  md5
postgresql__CMD_PREFIX ?= $(SERVICE_CMD_PREFIX)
postgresql__ENABLE = $(service__ENABLE)
postgresql__MAJOR ?= 12
postgresql__MINOR ?= 15_2
postgresql__OS ?= $(DEFAULT_OS)
postgresql__PG_HBA ?= /opt/homebrew/var/$(postgresql__SERVICE)/pg_hba.conf
postgresql__SERVICE ?= postgresql@$(postgresql__MAJOR)
postgresql__START_CMD ?= $(postgresql__CMD_PREFIX) start $(postgresql__SERVICE)
postgresql__STOP_CMD ?= $(postgresql__CMD_PREFIX) stop $(postgresql__SERVICE)
postgresql__SUDO_BIN ?= $(SUDO_BIN)
postgresql__SUDO_USER ?= $(SUDO_USER)
postgresql__TAGS = service

# cli
psql__ADMIN ?= postgres
psql__ADMIN_DB ?= postgres
psql__ADMIN_PASSWORD ?= postgres
psql__AUTH_METHOD ?= remote
psql__CNT =
psql__ENABLE = $(ENABLE_HOST)
psql__EXIT_IF_DB_EXISTS = no
psql__EXIT_IF_USER_EXISTS = no
psql__HOST ?= $(LOCALHOST)
psql__PORT ?= 5432
psql__SUDO_BIN ?= $(SUDO_BIN)
psql__SUDO_USER ?= $(SUDO_USER)
psql__USER_ATTRIBUTES ?= SUPERUSER CREATEDB
psql__USER_DB ?= $(DEFAULT_DB)
psql__USER_NAME ?= $(DEFAULT_USER)
psql__USER_PASSWORD ?= $(DEFAULT_PASSWORD)
psql__TAGS = clean cli
psql__CONN_URL ?= $(call conn_url,psql,postgres,$(psql__ADMIN),$(psql__ADMIN_PASSWORD),$(psql__HOST),$(psql__PORT),$(psql__ADMIN_DB))

# pg_ctl
pg_ctl__ENABLE = $(service__ENABLE)
pg_ctl__ADMIN ?= $(psql__ADMIN)
pg_ctl__ADMIN_DB ?= $(psql__ADMIN_DB)
pg_ctl__ADMIN_PASSWORD ?= $(psql__ADMIN_PASSWORD)
pg_ctl__DATADIR ?= $$(SELFDIR)/pg_data
pg_ctl__HOST ?= $(LOCALHOST)
pg_ctl__INITDB_AUTH_HOST ?= md5
pg_ctl__INITDB_AUTH_LOCAL ?= peer
pg_ctl__INITDB_PWFILE ?= /tmp/passwd.tmp
pg_ctl__LANG = $(LOCALE_LANG)
pg_ctl__LC_ALL = $(LOCALE_LC_ALL)
pg_ctl__LC_CTYPE = $(LOCALE_LC_CTYPE)
pg_ctl__OS_USER ?= $(pg_ctl__ADMIN)
pg_ctl__PG_CONFIG ?= $(shell which pg_config)
pg_ctl__PG_CTL_CONF ?= $$(DATADIR)/postgresql.conf
pg_ctl__PG_CTL_LOG ?= $$(DATADIR)/pg_ctl.logs
pg_ctl__PG_CTL_LOGGING_COLLECTOR ?= on
pg_ctl__PORT ?= $(psql__PORT)
pg_ctl__SUDO_BIN ?= $(SUDO_BIN)
pg_ctl__SUDO_USER = $(pg_ctl__OS_USER)
pg_ctl__TAGS = service