########################################################################################################################
# psql_foo
########################################################################################################################
ENABLE_CTX_psql_foo = $(ENABLE_ALL_CTXES)
TAG_psql_foo = init clean cli

psql_foo__IN = $(MK)/psql.mk
psql_foo__OUT_DIR = $(OUTDIR)/psql
psql_foo__OUT = $(psql_foo__OUT_DIR)/foo.mk

psql_foo__USER_DB = foo

CTXES += psql_foo

########################################################################################################################
# psql_bar
########################################################################################################################
ENABLE_CTX_psql_bar = $(ENABLE_ALL_CTXES)
TAG_psql_bar = init clean cli

psql_bar__IN = $(MK)/psql.mk
psql_bar__OUT_DIR = $(OUTDIR)/psql
psql_bar__OUT = $(psql_bar__OUT_DIR)/bar.mk

psql_bar__USER_DB = bar

CTXES += psql_bar

########################################################################################################################
# redis_cli
########################################################################################################################
ENABLE_CTX_redis_cli = $(ENABLE_ALL_CTXES)
TAG_redis_cli = init clean cli

redis_cli__IN = $(MK)/redis-cli.mk
redis_cli__OUT_DIR = $(OUTDIR)/redis-cli
redis_cli__OUT = $(redis_cli__OUT_DIR)/Makefile

CTXES += redis_cli

########################################################################################################################
# clickhouse_cli
########################################################################################################################
ENABLE_CTX_clickhouse_cli = $(ENABLE_ALL_CTXES)
TAG_clickhouse_cli = init clean cli

clickhouse_cli__IN = $(MK)/clickhouse-cli.mk
clickhouse_cli__OUT_DIR = $(OUTDIR)/clickhouse-cli
clickhouse_cli__OUT = $(clickhouse_cli__OUT_DIR)/Makefile

CTXES += clickhouse_cli
