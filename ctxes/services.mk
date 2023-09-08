########################################################################################################################
# postgresql
########################################################################################################################
ENABLE_CTX_postgresql = $(ENABLE_ALL_CTXES)
TAG_postgresql = host_service

postgresql__IN = $(TMPL_DIR)/postgresql/postgresql.mk
postgresql__OUT_DIR = $(OUTDIR)/postgresql
postgresql__OUT = $(postgresql__OUT_DIR)/postgresql.mk

CTXES += postgresql

########################################################################################################################
# redis
########################################################################################################################
ENABLE_CTX_redis = $(ENABLE_ALL_CTXES)
TAG_redis = host_service

redis__IN = $(TMPL_DIR)/redis/redis.mk
redis__OUT_DIR = $(OUTDIR)/redis
redis__OUT = $(redis__OUT_DIR)/redis.mk

CTXES += redis

########################################################################################################################
# clickhouse
########################################################################################################################
ENABLE_CTX_clickhouse = $(ENABLE_ALL_CTXES)
TAG_clickhouse = host_service

clickhouse__IN = $(TMPL_DIR)/clickhouse/clickhouse.mk
clickhouse__OUT_DIR = $(OUTDIR)/clickhouse
clickhouse__OUT = $(clickhouse__OUT_DIR)/clickhouse.mk
clickhouse__RENDER = $(RENDER)

CTXES += clickhouse

########################################################################################################################
# pg_ctl
########################################################################################################################
ENABLE_CTX_pg_ctl = $(ENABLE_ALL_CTXES)
TAG_pg_ctl = host_service

pg_ctl__IN = $(TMPL_DIR)/postgresql/pg_ctl.mk
pg_ctl__OUT_DIR = $(OUTDIR)/postgresql
pg_ctl__OUT = $(pg_ctl__OUT_DIR)/pg_ctl.mk

CTXES += pg_ctl