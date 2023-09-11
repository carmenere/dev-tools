DEVTOOLS_DIR := {{ DEVTOOLS_DIR }}

include $(DEVTOOLS_DIR)/lib.mk

ADMIN ?= {{ ADMIN }}
ADMIN_DB ?= {{ ADMIN_DB }}
ADMIN_PASSWORD ?= {{ ADMIN_PASSWORD }}
CNT = {{ CNT }}
HOST ?= {{ HOST }}
PORT ?= {{ PORT }}
USER_DB ?= {{ USER_DB }}
USER_NAME ?= {{ USER_NAME }}
USER_PASSWORD ?= {{ USER_PASSWORD }}

# 
ifdef CNT
    EXEC_CTX = docker exec $(TI) $(CNT)
else
    EXEC_CTX = 
endif

#
CLI ?= $(EXEC_CTX) clickhouse-client --user=$(ADMIN) --password=$(ADMIN_PASSWORD) --database=$(ADMIN_DB) \
	--host=$(HOST) --port=$(PORT) 

CLI_USER ?= $(EXEC_CTX) clickhouse-client --user=$(USER_NAME) --password=$(USER_PASSWORD) --database=$(USER_DB) \
	--host=$(HOST) --port=$(PORT)

#
.PHONY: default init init-force check-user check-superuser connect clean force-clean force-drop drop clear-db clean-artefacts distclean

default: init

create-user:
	$(CLI) --query="CREATE USER IF NOT EXISTS $(USER_NAME) IDENTIFIED WITH sha256_password BY '$(USER_PASSWORD)'"

create-db: create-user
	$(CLI) --query="CREATE DATABASE IF NOT EXISTS $(USER_DB)"

grant: create-db
	# Assign priviliges to user '$(USER_NAME)'
	$(CLI) --query="GRANT ALL ON $(USER_DB).* TO $(USER_NAME)"
	$(CLI) --query="GRANT ALL ON default.* TO $(USER_NAME)"

init: create-user create-db grant

connect: override TI = -ti
connect:
	$(CLI_USER)

connect-admin: override TI = -ti
connect-admin:
	$(CLI)

clean:
	$(CLI) --query="DROP DATABASE IF EXISTS $(USER_DB);"
	$(CLI) --query="DROP USER IF EXISTS $(USER_NAME);"

distclean: clean

include $(DEVTOOLS_DIR)/templates/common/lsof.mk
