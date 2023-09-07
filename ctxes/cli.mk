########################################################################################################################
# psql_foo
########################################################################################################################
ENABLE_CTX_psql_foo = $(ENABLE_ALL_CTXES)
TAG_psql_foo = clean cli

psql_foo__IN = $(MK)/psql.mk
psql_foo__OUT_DIR = $(OUTDIR)/psql
psql_foo__OUT = $(psql_foo__OUT_DIR)/foo.mk

psql_foo__USER_NAME = fizzfoo
psql_foo__USER_DB = foo

CTXES += psql_foo

########################################################################################################################
# psql_bar
########################################################################################################################
ENABLE_CTX_psql_bar = $(ENABLE_ALL_CTXES)
TAG_psql_bar = clean cli

psql_bar__IN = $(MK)/psql.mk
psql_bar__OUT_DIR = $(OUTDIR)/psql
psql_bar__OUT = $(psql_bar__OUT_DIR)/bar.mk

psql_bar__USER_NAME = fizzbar
psql_bar__USER_DB = bar

CTXES += psql_bar

########################################################################################################################
# psql_baz
########################################################################################################################
ENABLE_CTX_psql_baz = $(ENABLE_ALL_CTXES)
TAG_psql_baz = clean cli

psql_baz__IN = $(MK)/psql.mk
psql_baz__OUT_DIR = $(OUTDIR)/psql
psql_baz__OUT = $(psql_baz__OUT_DIR)/baz.mk

psql_baz__USER_NAME = fizzbaz
psql_baz__USER_DB = baz

CTXES += psql_baz

########################################################################################################################
# redis_cli
########################################################################################################################
ENABLE_CTX_redis_cli = $(ENABLE_ALL_CTXES)
TAG_redis_cli = clean cli

redis_cli__IN = $(MK)/redis-cli.mk
redis_cli__OUT_DIR = $(OUTDIR)/redis-cli
redis_cli__OUT = $(redis_cli__OUT_DIR)/Makefile

CTXES += redis_cli

########################################################################################################################
# clickhouse_cli
########################################################################################################################
ENABLE_CTX_clickhouse_cli = $(ENABLE_ALL_CTXES)
TAG_clickhouse_cli = clean cli

clickhouse_cli__IN = $(MK)/clickhouse-cli.mk
clickhouse_cli__OUT_DIR = $(OUTDIR)/clickhouse-cli
clickhouse_cli__OUT = $(clickhouse_cli__OUT_DIR)/Makefile

CTXES += clickhouse_cli
