########################################################################################################################
# docker_pg
########################################################################################################################
$(call inherit_ctx,docker__,docker_pg__)
$(call inherit_ctx,docker_service__,docker_pg__)

docker_pg__IN = $(TMPL_DIR)/docker/docker.mk
docker_pg__OUT_DIR = $(OUTDIR)/docker
docker_pg__OUT = $(docker_pg__OUT_DIR)/pg.mk

docker_pg__CONTAINER = pg
docker_pg__CTX = $(PROJECT_ROOT)
docker_pg__RESTART_POLICY = always

docker_pg__IMAGE = $(call docker_image,$(docker_pg__arg_BASE_IMAGE))

# build args for docker build
docker_pg__arg_BASE_IMAGE = $(DOCKER_PG_IMAGE)

# envs for docker run
docker_pg__env_POSTGRES_PASSWORD = $(psql__ADMIN_PASSWORD)
docker_pg__env_POSTGRES_DB = $(psql__ADMIN_DB)
docker_pg__env_POSTGRES_USER = $(psql__ADMIN)

CTXES += docker_pg

########################################################################################################################
# docker_redis
########################################################################################################################
$(call inherit_ctx,docker__,docker_redis__)
$(call inherit_ctx,docker_service__,docker_redis__)

docker_redis__IN = $(TMPL_DIR)/docker/docker.mk
docker_redis__OUT_DIR = $(OUTDIR)/docker
docker_redis__OUT = $(docker_redis__OUT_DIR)/redis.mk

docker_redis__CONTAINER = redis
docker_redis__CTX = $(PROJECT_ROOT)
docker_redis__RESTART_POLICY = always

docker_redis__IMAGE = $(call docker_image,$(docker_redis__arg_BASE_IMAGE))

# docker build_args
docker_redis__arg_BASE_IMAGE = $(DOCKER_REDIS_IMAGE)

CTXES += docker_redis

########################################################################################################################
# docker_clickhouse
########################################################################################################################
$(call inherit_ctx,docker__,docker_clickhouse__)
$(call inherit_ctx,docker_service__,docker_clickhouse__)

docker_clickhouse__IN = $(TMPL_DIR)/docker/docker.mk
docker_clickhouse__OUT_DIR = $(OUTDIR)/docker
docker_clickhouse__OUT = $(docker_clickhouse__OUT_DIR)/clickhouse.mk

docker_clickhouse__CONTAINER = clickhouse
docker_clickhouse__CTX = $(PROJECT_ROOT)
docker_clickhouse__RESTART_POLICY = always

docker_clickhouse__IMAGE = $(call docker_image,$(docker_clickhouse__arg_BASE_IMAGE))

# docker build_args
docker_clickhouse__arg_BASE_IMAGE = $(DOCKER_CLICKHOUSE_IMAGE)

# envs for docker run
docker_clickhouse__env_CLICKHOUSE_DB = $(clickhouse__ADMIN_DB)
docker_clickhouse__env_CLICKHOUSE_DEFAULT_ACCESS_MANAGEMENT = 1
docker_clickhouse__env_CLICKHOUSE_PASSWORD = $(clickhouse__ADMIN_PASSWORD)
docker_clickhouse__env_CLICKHOUSE_USER = $(clickhouse__ADMIN)

CTXES += docker_clickhouse
