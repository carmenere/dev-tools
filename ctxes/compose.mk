# ########################################################################################################################
CTX := example
# ########################################################################################################################
example__IN = $(MK)/compose.mk
example__OUT_DIR = $(d__OUTDIR)/compose
example__OUT = $(example__OUT_DIR)/example.mk
example__BRIDGE = $(d__DOCKER_NETWORK_NAME)
example__DRIVER = $(d__DOCKER_NETWORK_DRIVER)
example__NETWORK = $(d__DOCKER_NETWORK_SUBNET)

CTXES := $(CTXES) example

########################################################################################################################
CTX := example_redis
########################################################################################################################
$(call copy,docker_redis__,example_redis__)
example_redis__IN = $(TMPL_DIR)/compose/service.yaml
example_redis__OUT_DIR = $(TMPL_DIR)/compose/.tmp
example_redis__OUT = $(example_redis__OUT_DIR)/redis.yaml

example_redis__SERVICE = redis

CTXES := $(CTXES) example_redis

example_yaml__SERVICES += .tmp/redis.yaml

########################################################################################################################
CTX := example_pg
########################################################################################################################
$(call copy,docker_pg__,example_pg__)
example_pg__IN = $(TMPL_DIR)/compose/service.yaml
example_pg__OUT_DIR = $(TMPL_DIR)/compose/.tmp
example_pg__OUT = $(example_pg__OUT_DIR)/pg.yaml

example_pg__SERVICE = pg

CTXES := $(CTXES) example_pg

example_yaml__SERVICES += .tmp/pg.yaml


########################################################################################################################
CTX := example_clickhouse
########################################################################################################################
$(call copy,docker_clickhouse__,example_clickhouse__)
example_clickhouse__IN = $(TMPL_DIR)/compose/service.yaml
example_clickhouse__OUT_DIR = $(TMPL_DIR)/compose/.tmp
example_clickhouse__OUT = $(example_clickhouse__OUT_DIR)/clickhouse.yaml

example_clickhouse__SERVICE = clickhouse

CTXES := $(CTXES) example_clickhouse

example_yaml__SERVICES += .tmp/clickhouse.yaml

########################################################################################################################
CTX := example_rust
########################################################################################################################
$(call copy,docker_rust__,example_rust__)
example_rust__IN = $(TMPL_DIR)/compose/service.yaml
example_rust__OUT_DIR = $(TMPL_DIR)/compose/.tmp
example_rust__OUT = $(example_rust__OUT_DIR)/rust.yaml

example_rust__SERVICE = rust

CTXES := $(CTXES) example_rust

example_yaml__SERVICES += .tmp/rust.yaml

########################################################################################################################
CTX := example_foo
########################################################################################################################
$(call copy,docker_foo__,example_foo__)
example_foo__IN = $(TMPL_DIR)/compose/service.yaml
example_foo__OUT_DIR = $(TMPL_DIR)/compose/.tmp
example_foo__OUT = $(example_foo__OUT_DIR)/foo.yaml

example_foo__SERVICE = foo

CTXES := $(CTXES) example_foo

example_yaml__SERVICES += .tmp/foo.yaml

########################################################################################################################
CTX := example_bar
########################################################################################################################
$(call copy,docker_bar__,example_bar__)
example_bar__IN = $(TMPL_DIR)/compose/service.yaml
example_bar__OUT_DIR = $(TMPL_DIR)/compose/.tmp
example_bar__OUT = $(example_bar__OUT_DIR)/bar.yaml

example_bar__SERVICE = bar

CTXES := $(CTXES) example_bar

example_yaml__SERVICES += .tmp/bar.yaml

########################################################################################################################
CTX := example_yaml
########################################################################################################################
$(call copy,example__,example_yaml__)
example_yaml__IN = $(TMPL_DIR)/compose/stand.yaml
example_yaml__OUT_DIR = $(d__OUTDIR)/compose
example_yaml__OUT = $(example_yaml__OUT_DIR)/example.yaml

CTXES := $(CTXES) example_yaml

# stand_example__REDIS = redis
# stand_example__REDIS_RESTART_POLICY = $(docker_redis__RESTART_POLICY)
# stand_example__REDIS_ADMIN_PASSWORD = $(d__REDIS_ADMIN_PASSWORD)
# stand_example__REDIS_IMAGE = $(docker_redis__BASE_IMAGE)
# stand_example__REDIS_PUBLISH = $(docker_redis__PUBLISH)
# stand_example__REDIS_BRIDGE = $(stand_example__BRIDGE)


# ########################################################################################################################
# CTX := stand_example
# ########################################################################################################################
# stand_example__IN = $(DOCKER_COMPOSE)/stand.yaml
# stand_example__OUT_DIR = $(d__OUTDIR)/compose
# stand_example__OUT = $(stand_example__OUT_DIR)/example.yaml

# # RUST
# stand_example__RUST = rust
# stand_example__RUST_BASE_IMAGE = $(docker_rust__BASE_IMAGE) 
# stand_example__RUST_CTX = $(docker_rust__CTX)
# stand_example__RUST_DOCKERFILE = $(docker_rust__DOCKERFILE)
# stand_example__RUST_IMAGE = $(docker_rust__IMAGE)
# stand_example__RUST_VERSION = $(docker_rust__RUST_VERSION) 
# stand_example__SQLX_VERSION = $(docker_rust__SQLX_VERSION)
# stand_example__TARGET_ARCH = $(docker_rust__TARGET_ARCH) 

# # BAR
# stand_example__BAR = bar
# stand_example__BAR_RESTART_POLICY = $(docker_bar__RESTART_POLICY)
# stand_example__BAR_BASE_IMAGE = $(docker_bar__BASE_IMAGE)
# stand_example__BAR_BRIDGE = $(stand_example__BRIDGE)
# stand_example__BAR_BUILD_PROFILE = $(docker_bar__BUILD_PROFILE)
# stand_example__BAR_BUILD_VERSION = $(docker_bar__BUILD_VERSION)
# stand_example__BAR_BUILDER = $(stand_example__RUST_IMAGE)
# stand_example__BAR_CTX = $(docker_bar__CTX)
# stand_example__BAR_DOCKERFILE = $(docker_bar__DOCKERFILE)
# stand_example__BAR_IMAGE = $(docker_bar__IMAGE)
# stand_example__BAR_PUBLISH = $(docker_bar__PUBLISH)
# stand_example__BAR_TARGET_ARCH = $(docker_bar__TARGET_ARCH)
# stand_example__XX = 98765
# stand_example__YYY = qwerty

# # FOO
# stand_example__FOO = foo
# stand_example__FOO_RESTART_POLICY = $(docker_foo__RESTART_POLICY)
# stand_example__FOO_BASE_IMAGE = $(docker_foo__BASE_IMAGE)
# stand_example__FOO_BRIDGE = $(stand_example__BRIDGE)
# stand_example__FOO_BUILD_PROFILE = $(docker_foo__BUILD_PROFILE)
# stand_example__FOO_BUILD_VERSION = $(docker_foo__BUILD_VERSION)
# stand_example__FOO_BUILDER = $(stand_example__RUST_IMAGE)
# stand_example__FOO_CTX = $(docker_foo__CTX)
# stand_example__FOO_DOCKERFILE = $(docker_foo__DOCKERFILE)
# stand_example__FOO_IMAGE = $(docker_foo__IMAGE)
# stand_example__FOO_PUBLISH = $(docker_foo__PUBLISH)
# stand_example__FOO_TARGET_ARCH = $(docker_foo__TARGET_ARCH)
# stand_example__WWW = 98765
# stand_example__YY = qwerty


