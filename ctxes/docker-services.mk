########################################################################################################################
# docker_pg
########################################################################################################################
ENABLE_docker_pg = $(ENABLE_DOCKER_SERVICES)
docker_pg__STAGE = docker-services images

docker_pg__IN = $(MK)/docker.mk
docker_pg__OUT_DIR = $(OUTDIR)/docker
docker_pg__OUT = $(docker_pg__OUT_DIR)/pg.mk

docker_pg__CONTAINER = pg
docker_pg__CTX = $(PROJECT_ROOT)
docker_pg__RESTART_POLICY = always
docker_pg__RM_AFTER_STOP = no

docker_pg__IMAGE = $(call docker_image,$(docker_pg__arg_BASE_IMAGE))

# build args for docker build
docker_pg__arg_BASE_IMAGE = $(DOCKER_PG_IMAGE)

# envs for docker run
docker_pg__env_POSTGRES_PASSWORD = $(PG_ADMIN_PASSWORD)
docker_pg__env_POSTGRES_DB = $(PG_ADMIN_DB)
docker_pg__env_POSTGRES_USER = $(PG_ADMIN)

CTXES += docker_pg

########################################################################################################################
# docker_redis
########################################################################################################################
ENABLE_docker_redis = $(ENABLE_DOCKER_SERVICES)
docker_redis__STAGE = docker-services images

docker_redis__IN = $(MK)/docker.mk
docker_redis__OUT_DIR = $(OUTDIR)/docker
docker_redis__OUT = $(docker_redis__OUT_DIR)/redis.mk

docker_redis__CONTAINER = redis
docker_redis__CTX = $(PROJECT_ROOT)
docker_redis__RESTART_POLICY = always
docker_redis__RM_AFTER_STOP = no

docker_redis__IMAGE = $(call docker_image,$(docker_redis__arg_BASE_IMAGE))

# docker build_args
docker_redis__arg_BASE_IMAGE = $(DOCKER_REDIS_IMAGE)

CTXES += docker_redis

########################################################################################################################
# docker_clickhouse
########################################################################################################################
ENABLE_docker_clickhouse = $(ENABLE_DOCKER_SERVICES)
docker_clickhouse__STAGE = docker-services images

docker_clickhouse__IN = $(MK)/docker.mk
docker_clickhouse__OUT_DIR = $(OUTDIR)/docker
docker_clickhouse__OUT = $(docker_clickhouse__OUT_DIR)/clickhouse.mk

docker_clickhouse__CONTAINER = clickhouse
docker_clickhouse__CTX = $(PROJECT_ROOT)
docker_clickhouse__RESTART_POLICY = always
docker_clickhouse__RM_AFTER_STOP = no

docker_clickhouse__IMAGE = $(call docker_image,$(docker_clickhouse__arg_BASE_IMAGE))

# docker build_args
docker_clickhouse__arg_BASE_IMAGE = $(DOCKER_CLICKHOUSE_IMAGE)

# envs for docker run
docker_clickhouse__env_CLICKHOUSE_DB = $(CH_ADMIN_DB)
docker_clickhouse__env_CLICKHOUSE_DEFAULT_ACCESS_MANAGEMENT = 1
docker_clickhouse__env_CLICKHOUSE_PASSWORD = $(CH_ADMIN_PASSWORD)
docker_clickhouse__env_CLICKHOUSE_USER = $(CH_ADMIN)

CTXES += docker_clickhouse
