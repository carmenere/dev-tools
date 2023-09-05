########################################################################################################################
# psql
########################################################################################################################
ENABLE_psql = $(ENABLE_INIT)
psql__STAGE = init

psql__IN = $(MK)/psql.mk
psql__OUT_DIR = $(OUTDIR)/psql
psql__OUT = $(psql__OUT_DIR)/Makefile

CTXES += psql

########################################################################################################################
# redis_cli
########################################################################################################################
ENABLE_redis_cli = $(ENABLE_INIT)
redis_cli__STAGE = init

redis_cli__IN = $(MK)/redis-cli.mk
redis_cli__OUT_DIR = $(OUTDIR)/redis-cli
redis_cli__OUT = $(redis_cli__OUT_DIR)/Makefile

CTXES += redis_cli

########################################################################################################################
# clickhouse_cli
########################################################################################################################
ENABLE_clickhouse_cli = $(ENABLE_INIT)
clickhouse_cli__STAGE = init

clickhouse_cli__IN = $(MK)/clickhouse-cli.mk
clickhouse_cli__OUT_DIR = $(OUTDIR)/clickhouse-cli
clickhouse_cli__OUT = $(clickhouse_cli__OUT_DIR)/Makefile

CTXES += clickhouse_cli
