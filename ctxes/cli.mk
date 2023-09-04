########################################################################################################################
# psql
########################################################################################################################
ctx_psql__ENABLED = no
ctx_psql__STAGE = init

psql__IN = $(MK)/psql.mk
psql__OUT_DIR = $(d__OUTDIR)/psql
psql__OUT = $(psql__OUT_DIR)/Makefile

CTXES += psql

########################################################################################################################
# redis_cli
########################################################################################################################
ctx_redis_cli__ENABLED = no
ctx_redis_cli__STAGE = init

redis_cli__IN = $(MK)/redis-cli.mk
redis_cli__OUT_DIR = $(d__OUTDIR)/redis-cli
redis_cli__OUT = $(redis_cli__OUT_DIR)/Makefile

CTXES += redis_cli

########################################################################################################################
# clickhouse_cli
########################################################################################################################
ctx_clickhouse_cli__ENABLED = no
ctx_clickhouse_cli__STAGE = init

clickhouse_cli__IN = $(MK)/clickhouse-cli.mk
clickhouse_cli__OUT_DIR = $(d__OUTDIR)/clickhouse-cli
clickhouse_cli__OUT = $(clickhouse_cli__OUT_DIR)/Makefile

CTXES += clickhouse_cli
