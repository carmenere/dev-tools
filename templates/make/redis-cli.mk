TOPDIR := $(shell pwd)

ADMIN ?= {{ ADMIN }}
ADMIN_DB ?= {{ ADMIN_DB }}
ADMIN_PASSWORD ?= {{ ADMIN_PASSWORD }}
ARTEFACTS_DIR ?= {{ ARTEFACTS_DIR }}
CNT = {{ CNT }}
CONFIG_REWRITE ?= {{ CONFIG_REWRITE }}
EXIT_IF_CREATE_EXISTED_USER = {{ EXIT_IF_CREATE_EXISTED_USER }}
HOST ?= {{ HOST }}
MODE = {{ MODE }}
PORT ?= {{ PORT }}
REQUIREPASS ?= {{ REQUIREPASS }}
USER_DB ?= {{ USER_DB }}
USER_NAME := {{ USER_NAME }}
USER_PASSWORD ?= {{ USER_PASSWORD }}

CONN_URL ?= redis://$(ADMIN):$(ADMIN_PASSWORD)@$(HOST):$(PORT)/$(ADMIN_DB)
USER_CONN_URL ?= redis-cli -u redis://$(USER_NAME):$(USER_PASSWORD)@$(HOST):$(PORT)/$(USER_DB)

define check_user
$(REDIS_CLI) ACL DRYRUN $1 ACL WHOAMI
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
	[ ! -d $(ARTEFACTS_DIR) ] || rm -Rf $(ARTEFACTS_DIR)
