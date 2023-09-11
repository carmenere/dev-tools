DEVTOOLS_DIR := {{ DEVTOOLS_DIR }}

include $(DEVTOOLS_DIR)/lib.mk

ADMIN ?= {{ ADMIN }}
ADMIN_DB ?= {{ ADMIN_DB }}
ADMIN_PASSWORD ?= {{ ADMIN_PASSWORD }}
CNT = {{ CNT }}
CONFIG_REWRITE ?= {{ CONFIG_REWRITE }}
EXIT_IF_USER_EXISTS = {{ EXIT_IF_USER_EXISTS }}
HOST ?= {{ HOST }}
PORT ?= {{ PORT }}
REQUIREPASS ?= {{ REQUIREPASS }}
USER_DB ?= {{ USER_DB }}
USER_NAME := {{ USER_NAME }}
USER_PASSWORD ?= {{ USER_PASSWORD }}

CONN_URL ?= {{ CONN_URL }}
USER_CONN_URL ?= {{ USER_CONN_URL }}

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
	$(call check_user,$(USER_NAME)); if [ "$$?" = 0 ] && [ "$(EXIT_IF_USER_EXISTS)" = yes ]; then false; fi
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

include $(DEVTOOLS_DIR)/templates/common/lsof.mk
