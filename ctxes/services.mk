########################################################################################################################
# postgresql
########################################################################################################################
ctx_postgresql__ENABLED = no
ctx_postgresql__STAGE = services

postgresql__IN = $(MK)/postgresql.mk
postgresql__OUT_DIR = $(d__OUTDIR)/postgresql
postgresql__OUT = $(postgresql__OUT_DIR)/Makefile

CTXES += postgresql

########################################################################################################################
# redis
########################################################################################################################
ctx_redis__ENABLED = no
ctx_redis__STAGE = services

redis__IN = $(MK)/redis.mk
redis__OUT_DIR = $(d__OUTDIR)/redis
redis__OUT = $(redis__OUT_DIR)/Makefile

CTXES += redis

########################################################################################################################
# clickhouse
########################################################################################################################
ctx_clickhouse__ENABLED = no
ctx_clickhouse__STAGE = services

clickhouse__IN = $(MK)/clickhouse.mk
clickhouse__OUT_DIR = $(d__OUTDIR)/clickhouse
clickhouse__OUT = $(clickhouse__OUT_DIR)/Makefile
clickhouse__RENDER = $(RENDER)

CTXES += clickhouse

########################################################################################################################
# pg_ctl
########################################################################################################################
ctx_pg_ctl__ENABLED = no
ctx_pg_ctl__STAGE = services

pg_ctl__IN = $(MK)/pg_ctl.mk
pg_ctl__OUT_DIR = $(d__OUTDIR)/pg_ctl
pg_ctl__OUT = $(pg_ctl__OUT_DIR)/Makefile

CTXES += pg_ctl