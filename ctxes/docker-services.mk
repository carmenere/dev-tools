########################################################################################################################
# docker_pg
########################################################################################################################
ctx_docker_pg__ENABLED = no
ctx_docker_pg__STAGE = docker-services images

docker_pg__IN = $(MK)/docker.mk
docker_pg__OUT_DIR = $(d__OUTDIR)/docker
docker_pg__OUT = $(docker_pg__OUT_DIR)/pg.mk

docker_pg__CONTAINER = pg
docker_pg__CTX = $(d__PROJECT_ROOT)
docker_pg__RESTART_POLICY = always
docker_pg__RM_AFTER_STOP = no

docker_pg__IMAGE = $(call docker_image,$(docker_pg__arg_BASE_IMAGE))

# build args for docker build
docker_pg__arg_BASE_IMAGE = $(d__DOCKER_PG_IMAGE)

# envs for docker run
docker_pg__env_POSTGRES_PASSWORD = $(d__PG_ADMIN_PASSWORD)
docker_pg__env_POSTGRES_DB = $(d__PG_ADMIN_DB)
docker_pg__env_POSTGRES_USER = $(d__PG_ADMIN)

CTXES += docker_pg

########################################################################################################################
# docker_redis
########################################################################################################################
ctx_docker_redis__ENABLED = no
ctx_docker_redis__STAGE = docker-services images

docker_redis__IN = $(MK)/docker.mk
docker_redis__OUT_DIR = $(d__OUTDIR)/docker
docker_redis__OUT = $(docker_redis__OUT_DIR)/redis.mk

docker_redis__CONTAINER = redis
docker_redis__CTX = $(d__PROJECT_ROOT)
docker_redis__RESTART_POLICY = always
docker_redis__RM_AFTER_STOP = no

docker_redis__IMAGE = $(call docker_image,$(docker_redis__arg_BASE_IMAGE))

# docker build_args
docker_redis__arg_BASE_IMAGE = $(d__DOCKER_REDIS_IMAGE)

CTXES += docker_redis

########################################################################################################################
# docker_clickhouse
########################################################################################################################
ctx_docker_clickhouse__ENABLED = no
ctx_docker_clickhouse__STAGE = docker-services images

docker_clickhouse__IN = $(MK)/docker.mk
docker_clickhouse__OUT_DIR = $(d__OUTDIR)/docker
docker_clickhouse__OUT = $(docker_clickhouse__OUT_DIR)/clickhouse.mk

docker_clickhouse__CONTAINER = clickhouse
docker_clickhouse__CTX = $(d__PROJECT_ROOT)
docker_clickhouse__RESTART_POLICY = always
docker_clickhouse__RM_AFTER_STOP = no

docker_clickhouse__IMAGE = $(call docker_image,$(docker_clickhouse__arg_BASE_IMAGE))

# docker build_args
docker_clickhouse__arg_BASE_IMAGE = $(d__DOCKER_CLICKHOUSE_IMAGE)

# envs for docker run
docker_clickhouse__env_CLICKHOUSE_DB = $(d__CH_ADMIN_DB)
docker_clickhouse__env_CLICKHOUSE_DEFAULT_ACCESS_MANAGEMENT = 1
docker_clickhouse__env_CLICKHOUSE_PASSWORD = $(d__CH_ADMIN_PASSWORD)
docker_clickhouse__env_CLICKHOUSE_USER = $(d__CH_ADMIN)

CTXES += docker_clickhouse
