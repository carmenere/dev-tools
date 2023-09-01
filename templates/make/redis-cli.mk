DEVTOOLS_DIR := {{ DEVTOOLS_DIR }}

include $(DEVTOOLS_DIR)/configure/defaults.mk
include $(DEVTOOLS_DIR)/templates/make/common/lib.mk

include {{ SETTINGS }}

ADMIN ?= {{ ADMIN | default('$(d__REDIS_ADMIN)', true) }}
ADMIN_DB ?= {{ ADMIN_DB | default('$(d__REDIS_ADMIN_DB)', true) }}
ADMIN_PASSWORD ?= {{ ADMIN_PASSWORD | default('$(d__REDIS_ADMIN_PASSWORD)', true) }}
CNT = {{ CNT | default('', true) }}
CONFIG_REWRITE ?= {{ CONFIG_REWRITE | default('yes', true) }}
EXIT_IF_CREATE_EXISTED_USER = {{ EXIT_IF_CREATE_EXISTED_USER | default('$(d__EXIT_IF_CREATE_EXISTED_USER)', true) }}
HOST ?= {{ HOST | default('$(d__REDIS_HOST)', true) }}
PORT ?= {{ PORT | default('$(d__REDIS_PORT)', true) }}
REQUIREPASS ?= {{ REQUIREPASS | default('yes', true) }}
USER_DB ?= {{ USER_DB | default('$(d__REDIS_ADMIN_DB)', true) }}
USER_NAME := {{ USER_NAME | default('$(d__SERVICE_USER)', true) }}
USER_PASSWORD ?= {{ USER_PASSWORD | default('$(d__SERVICE_PASSWORD)', true) }}

CONN_URL ?= redis://$(ADMIN):$(ADMIN_PASSWORD)@$(HOST):$(PORT)/$(ADMIN_DB)
USER_CONN_URL ?= redis://$(USER_NAME):$(USER_PASSWORD)@$(HOST):$(PORT)/$(USER_DB)

define check_user
$(REDIS_CLI) ACL DRYRUN $1 PING
endef

#
ifdef CNT
    REDIS_CLI ?= docker exec $(TI) $(CNT) redis-cli -e -u $(CONN_URL)
    REDIS_CLI_USER ?= docker exec $(TI) $(CNT) redis-cli -e -u $(USER_CONN_URL)
    CONFIG_REWRITE = no
else
    REDIS_CLI ?= redis-cli -e -u $(CONN_URL)
    REDIS_CLI_USER ?= redis-cli -e -u $(USER_CONN_URL)
endif

.PHONY: init create-user rm-user connect connect-admin flush clean distclean

requirepass:
ifeq ($(REQUIREPASS),yes)
	$(REDIS_CLI) config set requirepass "$(ADMIN_PASSWORD)"
endif

create-user:
	$(call check_user,$(USER_NAME)); if [ "$$?" = 0 ] && [ "$(EXIT_IF_CREATE_EXISTED_USER)" = yes ]; then false; fi
	$(call check_user,$(USER_NAME)); if [ "$$?" != 0 ]; then $(REDIS_CLI) ACL SETUSER $(USER_NAME) \>$(USER_PASSWORD) on allkeys allcommands; fi

rm-user:
	$(call check_user,$(USER_NAME)); if [ "$$?" = 0 ]; then $(REDIS_CLI) ACL DELUSER $(USER_NAME); fi

init: requirepass create-user save

connect: override TI = -ti
connect:
	$(REDIS_CLI_USER)

connect-admin: override TI = -ti
connect-admin:
	$(REDIS_CLI)

flush:
	$(REDIS_CLI) FLUSHALL
	$(REDIS_CLI) config set requirepass ""

save:
ifeq ($(CONFIG_REWRITE),yes)
	$(REDIS_CLI) CONFIG REWRITE
endif

clean: rm-user flush save

distclean: clean

lsof:
ifneq ($(HOST),0.0.0.0)
	sudo lsof -nP -i4TCP@0.0.0.0:$(PORT) || true
endif
ifneq ($(HOST),localhost)
	sudo lsof -nP -i4TCP@localhost:$(PORT) || true
endif
	sudo lsof -nP -i4TCP@$(HOST):$(PORT) || true
