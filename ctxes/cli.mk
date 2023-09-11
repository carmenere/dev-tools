########################################################################################################################
# psql_foo
########################################################################################################################
$(call inherit_ctx,psql__,psql_foo__)

# $(error HERE - psql_foo__USER_NAME = $(psql_foo__USER_NAME))

psql_foo__IN = $(TMPL_DIR)/postgresql/psql.mk
psql_foo__OUT_DIR = $(OUTDIR)/postgresql/psql
psql_foo__OUT = $(psql_foo__OUT_DIR)/foo.mk

psql_foo__USER_NAME = fizzfoo
psql_foo__USER_DB = foo

# $1:ctx $2:SCHEMA $3:USER; $4:PASSWORD, $5:HOST, $6:PORT, $7:DB
psql_foo__CONN_URL ?= $(psql__CONN_URL)
psql_foo__USER_CONN_URL ?= $(call conn_url,psql_foo,postgres,,,,$(psql_foo__PORT),)

CTXES += psql_foo

########################################################################################################################
# psql_bar
########################################################################################################################
$(call inherit_ctx,psql__,psql_bar__)

psql_bar__IN = $(TMPL_DIR)/postgresql/psql.mk
psql_bar__OUT_DIR = $(OUTDIR)/postgresql/psql
psql_bar__OUT = $(psql_bar__OUT_DIR)/bar.mk

psql_bar__USER_NAME = fizzbar
psql_bar__USER_DB = bar

psql_bar__CONN_URL ?= $(psql__CONN_URL)
psql_bar__USER_CONN_URL ?= $(call conn_url,psql_bar,postgres,,,,$(psql_bar__PORT),)

CTXES += psql_bar

########################################################################################################################
# psql_baz
########################################################################################################################
$(call inherit_ctx,psql__,psql_baz__)

psql_baz__IN = $(TMPL_DIR)/postgresql/psql.mk
psql_baz__OUT_DIR = $(OUTDIR)/postgresql/psql
psql_baz__OUT = $(psql_baz__OUT_DIR)/baz.mk

psql_baz__USER_NAME = fizzbaz
psql_baz__USER_DB = baz

psql_baz__CONN_URL ?= $(psql__CONN_URL)
psql_baz__USER_CONN_URL ?= $(call conn_url,psql_baz,postgres,,,,$(psql_baz__PORT),)

CTXES += psql_baz

########################################################################################################################
# redis_cli
########################################################################################################################
redis_cli__IN = $(TMPL_DIR)/redis/cli.mk
redis_cli__OUT_DIR = $(OUTDIR)/redis
redis_cli__OUT = $(redis_cli__OUT_DIR)/cli.mk

redis_cli__USER_CONN_URL ?= $(call conn_url,redis_cli,redis,,,,$(redis_cli__PORT),)

CTXES += redis_cli

########################################################################################################################
# clickhouse_cli
########################################################################################################################
clickhouse_cli__IN = $(TMPL_DIR)/clickhouse/cli.mk
clickhouse_cli__OUT_DIR = $(OUTDIR)/clickhouse
clickhouse_cli__OUT = $(clickhouse_cli__OUT_DIR)/cli.mk

CTXES += clickhouse_cli
