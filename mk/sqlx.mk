# Includes
include $(ARTEFACTS)/.env.sqlx

### Targets
.PHONY: default env migrate migrate-revert

default: env

env:
	@echo $(foreach e,$(ENVs),export $(e)=\'$($(e))\'"\n") export ENVs=\'$(ENVs)\'"\n"

migrate:
	cd $(POSTGRES_MIGRATIONS) && sqlx migrate run

migrate-revert:
	cd $(POSTGRES_MIGRATIONS) && sqlx migrate revert