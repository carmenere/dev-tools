# server
clickhouse__ADMIN ?= admin
clickhouse__ADMIN_PASSWORD ?= 12345
clickhouse__CMD_PREFIX ?= $(SERVICE_CMD_PREFIX)
clickhouse__ENABLE = $(service__ENABLE)
clickhouse__MAJOR ?= 23.5
clickhouse__MINOR ?= 
clickhouse__OS ?= $(DEFAULT_OS)
clickhouse__RENDER ?= $(RENDER)
clickhouse__SERVICE ?= clickhouse@$(clickhouse__MAJOR)
clickhouse__START_CMD ?= $(clickhouse__CMD_PREFIX) start $(clickhouse__SERVICE)
clickhouse__STOP_CMD ?= $(clickhouse__CMD_PREFIX) stop $(clickhouse__SERVICE)
clickhouse__SUDO_BIN ?= $(SUDO_BIN)
clickhouse__SUDO_USER ?= $(SUDO_USER)
clickhouse__USER_XML = /opt/homebrew/etc/clickhouse-server/users.d/$(clickhouse__ADMIN).xml
clickhouse__TAGS = service

# cli
clickhouse_cli__ADMIN ?= $(clickhouse__ADMIN)
clickhouse_cli__ADMIN_DB ?= default
clickhouse_cli__ADMIN_PASSWORD ?= $(clickhouse__ADMIN_PASSWORD)
clickhouse_cli__CNT ?=
clickhouse_cli__ENABLE = $(ENABLE_HOST)
clickhouse_cli__HOST ?= $(LOCALHOST)
clickhouse_cli__PORT ?= 9000
clickhouse_cli__USER_DB ?= $(DEFAULT_DB)
clickhouse_cli__USER_NAME ?= $(DEFAULT_USER)
clickhouse_cli__USER_PASSWORD ?= $(DEFAULT_PASSWORD)
clickhouse_cli__TAGS = clean cli