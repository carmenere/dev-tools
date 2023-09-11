# server
redis__TAGS = $(service__TAGS)
redis__ENABLE = $(service__ENABLE)
redis__CMD_PREFIX ?= $(SERVICE_CMD_PREFIX)
redis__MAJOR ?= 7
redis__MINOR ?= 0.1
redis__OS ?= $(DEFAULT_OS)
redis__SERVICE ?= redis
redis__START_CMD ?= $(redis__CMD_PREFIX) start $(redis__SERVICE)
redis__STOP_CMD ?= $(redis__CMD_PREFIX) stop $(redis__SERVICE)
redis__SUDO_BIN ?= $(SUDO_BIN)
redis__SUDO_USER ?= $(SUDO_USER)
redis__VERSION ?= $(redis__MAJOR).$(redis__MINOR)

# cli
redis_cli__TAGS = clean cli
redis_cli__ENABLE = $(ENABLE_HOST)
redis_cli__ADMIN ?= default
redis_cli__ADMIN_DB ?= 0
redis_cli__ADMIN_PASSWORD ?=
redis_cli__CNT =
redis_cli__CONFIG_REWRITE ?= yes
redis_cli__EXIT_IF_USER_EXISTS = no
redis_cli__HOST ?=  $(LOCALHOST)
redis_cli__PORT ?= 6379
redis_cli__REQUIREPASS ?= yes
redis_cli__USER_DB ?= 0
redis_cli__USER_NAME ?= $(DEFAULT_USER)
redis_cli__USER_PASSWORD ?= $(DEFAULT_PASSWORD)
redis_cli__CONN_URL ?= $(call conn_url,redis,redis,$(redis_cli__ADMIN),$(redis_cli__ADMIN_PASSWORD),$(redis_cli__HOST),$(redis_cli__PORT),$(redis_cli__ADMIN_DB))

