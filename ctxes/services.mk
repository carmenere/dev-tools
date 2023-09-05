########################################################################################################################
# postgresql
########################################################################################################################
ENABLE_postgresql = $(ENABLE_HOST_SERVICES)
postgresql__STAGE = services

postgresql__IN = $(MK)/postgresql.mk
postgresql__OUT_DIR = $(OUTDIR)/postgresql
postgresql__OUT = $(postgresql__OUT_DIR)/Makefile

CTXES += postgresql

########################################################################################################################
# redis
########################################################################################################################
ENABLE_redis = $(ENABLE_HOST_SERVICES)
redis__STAGE = services

redis__IN = $(MK)/redis.mk
redis__OUT_DIR = $(OUTDIR)/redis
redis__OUT = $(redis__OUT_DIR)/Makefile

CTXES += redis

########################################################################################################################
# clickhouse
########################################################################################################################
ENABLE_clickhouse = $(ENABLE_HOST_SERVICES)
clickhouse__STAGE = services

clickhouse__IN = $(MK)/clickhouse.mk
clickhouse__OUT_DIR = $(OUTDIR)/clickhouse
clickhouse__OUT = $(clickhouse__OUT_DIR)/Makefile
clickhouse__RENDER = $(RENDER)

CTXES += clickhouse

########################################################################################################################
# pg_ctl
########################################################################################################################
ENABLE_pg_ctl = $(ENABLE_HOST_SERVICES)
pg_ctl__STAGE = services

pg_ctl__IN = $(MK)/pg_ctl.mk
pg_ctl__OUT_DIR = $(OUTDIR)/pg_ctl
pg_ctl__OUT = $(pg_ctl__OUT_DIR)/Makefile

CTXES += pg_ctl