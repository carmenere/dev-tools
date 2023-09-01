
########################################################################################################################
CTX := stand_example
########################################################################################################################
stand_example__IN = $(DOCKER_COMPOSE)/stand.yaml
stand_example__OUT_DIR = $(d__OUTDIR)/compose
stand_example__OUT = $(stand_example__OUT_DIR)/example.yaml

# RUST
stand_example__RUST = rust
stand_example__RUST_BASE_IMAGE = $(docker_rust__BASE_IMAGE) 
stand_example__RUST_CTX = $(docker_rust__CTX)
stand_example__RUST_DOCKERFILE = $(docker_rust__DOCKERFILE)
stand_example__RUST_IMAGE = $(docker_rust__IMAGE)
stand_example__RUST_VERSION = $(docker_rust__RUST_VERSION) 
stand_example__SQLX_VERSION = $(docker_rust__SQLX_VERSION)
stand_example__TARGET_ARCH = $(docker_rust__TARGET_ARCH) 

# BAR
stand_example__BAR = bar
stand_example__BAR_RESTART_POLICY = $(docker_bar__RESTART_POLICY)
stand_example__BAR_BASE_IMAGE = $(docker_bar__BASE_IMAGE)
stand_example__BAR_BRIDGE = $(stand_example__BRIDGE)
stand_example__BAR_BUILD_PROFILE = $(docker_bar__BUILD_PROFILE)
stand_example__BAR_BUILD_VERSION = $(docker_bar__BUILD_VERSION)
stand_example__BAR_BUILDER = $(stand_example__RUST_IMAGE)
stand_example__BAR_CTX = $(docker_bar__CTX)
stand_example__BAR_DOCKERFILE = $(docker_bar__DOCKERFILE)
stand_example__BAR_IMAGE = $(docker_bar__IMAGE)
stand_example__BAR_PUBLISH = $(docker_bar__PUBLISH)
stand_example__BAR_TARGET_ARCH = $(docker_bar__TARGET_ARCH)
stand_example__XX = 98765
stand_example__YYY = qwerty

# FOO
stand_example__FOO = foo
stand_example__FOO_RESTART_POLICY = $(docker_foo__RESTART_POLICY)
stand_example__FOO_BASE_IMAGE = $(docker_foo__BASE_IMAGE)
stand_example__FOO_BRIDGE = $(stand_example__BRIDGE)
stand_example__FOO_BUILD_PROFILE = $(docker_foo__BUILD_PROFILE)
stand_example__FOO_BUILD_VERSION = $(docker_foo__BUILD_VERSION)
stand_example__FOO_BUILDER = $(stand_example__RUST_IMAGE)
stand_example__FOO_CTX = $(docker_foo__CTX)
stand_example__FOO_DOCKERFILE = $(docker_foo__DOCKERFILE)
stand_example__FOO_IMAGE = $(docker_foo__IMAGE)
stand_example__FOO_PUBLISH = $(docker_foo__PUBLISH)
stand_example__FOO_TARGET_ARCH = $(docker_foo__TARGET_ARCH)
stand_example__WWW = 98765
stand_example__YY = qwerty

# PG
stand_example__PG = pg
stand_example__PG_RESTART_POLICY = $(docker_pg__RESTART_POLICY)
stand_example__PG_IMAGE = $(docker_pg__BASE_IMAGE)
stand_example__PG_PUBLISH = $(docker_pg__PUBLISH)
stand_example__PG_BRIDGE = $(stand_example__BRIDGE)
stand_example__POSTGRES_PASSWORD = $(docker_pg__)
stand_example__POSTGRES_DB = $(docker_pg__POSTGRES_DB)
stand_example__POSTGRES_USER = $(docker_pg__POSTGRES_USER)

# REDIS
stand_example__REDIS = redis
stand_example__REDIS_RESTART_POLICY = $(docker_redis__RESTART_POLICY)
stand_example__REDIS_ADMIN_PASSWORD = $(d__REDIS_ADMIN_PASSWORD)
stand_example__REDIS_IMAGE = $(docker_redis__BASE_IMAGE)
stand_example__REDIS_PUBLISH = $(docker_redis__PUBLISH)
stand_example__REDIS_BRIDGE = $(stand_example__BRIDGE)

# NETWORKS
stand_example__BRIDGE = example
stand_example__DRIVER = $(d__DOCKER_NETWORK_DRIVER)
stand_example__NETWORK = 192.168.200.0/24

# PG_ENVS
stand_example__PG_ENVS = $(call list_by_prefix,docker_pg__env_)

# BAR_ENVS
stand_example__BAR_ENVS = XX YYY

# FOO_ENVS
stand_example__FOO_ENVS = WWW YY

CTXES := $(CTXES) stand_example
