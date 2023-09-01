########################################################################################################################
CTX := docker_pg
########################################################################################################################
ctx_docker_pg__ENABLED = $(d__DOCKER_SERVICES_ENABLED)
ctx_docker_pg__STAGE = services

docker_pg__IN = $(MK)/docker.mk
docker_pg__OUT_DIR = $(d__OUTDIR)/docker
docker_pg__OUT = $(docker_pg__OUT_DIR)/pg.mk

docker_pg__CONTAINER = pg
docker_pg__CTX = $(d__PROJECT_ROOT)
docker_pg__RESTART_POLICY = always
docker_pg__RM_AFTER_STOP = no

# build args for docker build
docker_pg__arg_BASE_IMAGE = $(DOCKER_PG_IMAGE)

docker_pg__BUILD_ARGS = $(call list_by_prefix,docker_pg__arg_)

# envs for docker run
docker_pg__env_POSTGRES_PASSWORD = $(ADMIN_PASSWORD)
docker_pg__env_POSTGRES_DB = $(ADMIN_DB)
docker_pg__env_POSTGRES_USER = $(ADMIN)

docker_pg__ENVS = $(call list_by_prefix,docker_pg__env_)

CTXES := $(CTXES) docker_pg

########################################################################################################################
CTX := docker_redis
########################################################################################################################
ctx_docker_redis__ENABLED = $(d__DOCKER_SERVICES_ENABLED)
ctx_docker_redis__STAGE = services

docker_redis__IN = $(MK)/docker.mk
docker_redis__OUT_DIR = $(d__OUTDIR)/docker
docker_redis__OUT = $(docker_redis__OUT_DIR)/redis.mk

docker_redis__CONTAINER = redis
docker_redis__CTX = $(d__PROJECT_ROOT)
docker_redis__RESTART_POLICY = always
docker_redis__RM_AFTER_STOP = no

# docker build_args
docker_redis__arg_BASE_IMAGE = $(d__DOCKER_REDIS_IMAGE)

docker_redis__BUILD_ARGS = $(call list_by_prefix,docker_redis__arg_)

docker_redis__ENVS = 

CTXES := $(CTXES) docker_redis

########################################################################################################################
CTX := docker_clickhouse
########################################################################################################################
ctx_docker_clickhouse__ENABLED = $(d__DOCKER_SERVICES_ENABLED)
ctx_docker_clickhouse__STAGE = services

docker_clickhouse__IN = $(MK)/docker.mk
docker_clickhouse__OUT_DIR = $(d__OUTDIR)/docker
docker_clickhouse__OUT = $(docker_clickhouse__OUT_DIR)/clickhouse.mk

docker_clickhouse__CONTAINER = clickhouse
docker_clickhouse__CTX = $(d__PROJECT_ROOT)
docker_clickhouse__RESTART_POLICY = always
docker_clickhouse__RM_AFTER_STOP = no

# docker build_args
docker_clickhouse__arg_BASE_IMAGE = $(d__DOCKER_CLICKHOUSE_IMAGE)

docker_clickhouse__BUILD_ARGS = $(call list_by_prefix,docker_clickhouse__arg_)

docker_clickhouse__ENVS = 

CTXES := $(CTXES) docker_clickhouse
