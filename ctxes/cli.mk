########################################################################################################################
CTX := psql
########################################################################################################################
ctx_psql__ENABLED = yes
ctx_psql__STAGE = init

psql__IN = $(MK)/psql.mk
psql__OUT_DIR = $(d__OUTDIR)/psql
psql__OUT = $(psql__OUT_DIR)/Makefile

CTXES := $(CTXES) psql

########################################################################################################################
CTX := redis_cli
########################################################################################################################
ctx_redis_cli__ENABLED = yes
ctx_redis_cli__STAGE = init

redis_cli__IN = $(MK)/redis-cli.mk
redis_cli__OUT_DIR = $(d__OUTDIR)/redis-cli
redis_cli__OUT = $(redis_cli__OUT_DIR)/Makefile

CTXES := $(CTXES) redis_cli

########################################################################################################################
CTX := clickhouse_cli
########################################################################################################################
ctx_clickhouse_cli__ENABLED = yes
ctx_clickhouse_cli__STAGE = init

clickhouse_cli__IN = $(MK)/clickhouse-cli.mk
clickhouse_cli__OUT_DIR = $(d__OUTDIR)/clickhouse-cli
clickhouse_cli__OUT = $(clickhouse_cli__OUT_DIR)/Makefile

CTXES := $(CTXES) clickhouse_cli
