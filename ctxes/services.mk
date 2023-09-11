########################################################################################################################
# postgresql
########################################################################################################################
postgresql__IN = $(TMPL_DIR)/postgresql/postgresql.mk
postgresql__OUT_DIR = $(OUTDIR)/postgresql
postgresql__OUT = $(postgresql__OUT_DIR)/postgresql.mk

CTXES += postgresql

########################################################################################################################
# redis
########################################################################################################################
redis__IN = $(TMPL_DIR)/redis/redis.mk
redis__OUT_DIR = $(OUTDIR)/redis
redis__OUT = $(redis__OUT_DIR)/redis.mk

CTXES += redis

########################################################################################################################
# clickhouse
########################################################################################################################
clickhouse__IN = $(TMPL_DIR)/clickhouse/clickhouse.mk
clickhouse__OUT_DIR = $(OUTDIR)/clickhouse
clickhouse__OUT = $(clickhouse__OUT_DIR)/clickhouse.mk
clickhouse__RENDER = $(RENDER)

CTXES += clickhouse

########################################################################################################################
# pg_ctl
########################################################################################################################
pg_ctl__IN = $(TMPL_DIR)/postgresql/pg_ctl.mk
pg_ctl__OUT_DIR = $(OUTDIR)/postgresql
pg_ctl__OUT = $(pg_ctl__OUT_DIR)/pg_ctl.mk

CTXES += pg_ctl