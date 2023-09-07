########################################################################################################################
# postgresql
########################################################################################################################
ENABLE_CTX_postgresql = $(ENABLE_ALL_CTXES)
TAG_postgresql = host_service

postgresql__IN = $(MK)/postgresql.mk
postgresql__OUT_DIR = $(OUTDIR)/postgresql
postgresql__OUT = $(postgresql__OUT_DIR)/Makefile

CTXES += postgresql

########################################################################################################################
# redis
########################################################################################################################
ENABLE_CTX_redis = $(ENABLE_ALL_CTXES)
TAG_redis = host_service

redis__IN = $(MK)/redis.mk
redis__OUT_DIR = $(OUTDIR)/redis
redis__OUT = $(redis__OUT_DIR)/Makefile

CTXES += redis

########################################################################################################################
# clickhouse
########################################################################################################################
ENABLE_CTX_clickhouse = $(ENABLE_ALL_CTXES)
TAG_clickhouse = host_service

clickhouse__IN = $(MK)/clickhouse.mk
clickhouse__OUT_DIR = $(OUTDIR)/clickhouse
clickhouse__OUT = $(clickhouse__OUT_DIR)/Makefile
clickhouse__RENDER = $(RENDER)

CTXES += clickhouse

########################################################################################################################
# pg_ctl
########################################################################################################################
ENABLE_CTX_pg_ctl = $(ENABLE_ALL_CTXES)
TAG_pg_ctl = host_service

pg_ctl__IN = $(MK)/pg_ctl.mk
pg_ctl__OUT_DIR = $(OUTDIR)/pg_ctl
pg_ctl__OUT = $(pg_ctl__OUT_DIR)/Makefile

CTXES += pg_ctl