########################################################################################################################
# INHERIT_VARS
########################################################################################################################
INHERIT_VARS += CONTAINER
INHERIT_VARS += CTX
INHERIT_VARS += DOCKERFILE
INHERIT_VARS += IMAGE
INHERIT_VARS += PUBLISH
INHERIT_VARS += BRIDGE

########################################################################################################################
# example
########################################################################################################################
$(call inherit_ctx,compose__,example__)

example__IN = $(TMPL_DIR)/docker/compose.mk
example__OUT_DIR = $(OUTDIR)/docker/compose
example__OUT = $(example__OUT_DIR)/example.mk

example__PROJECT = example
example__YAML = $(example_yaml__OUT_DIR)/example.yaml

example__BRIDGE = $(docker__BRIDGE)
example__DRIVER = $(docker__DRIVER)
example__SUBNET = $(docker__SUBNET)

CTXES += example

########################################################################################################################
# example_redis
########################################################################################################################
$(call inherit_ctx,yaml__,example_redis__)
example_redis__IN = $(TMPL_DIR)/docker/yamls/service.yaml
example_redis__OUT_DIR = $(TMPL_DIR)/docker/yamls/.tmp
example_redis__OUT = $(example_redis__OUT_DIR)/redis.yaml

$(call inherit_vars,docker_redis__,$(INHERIT_VARS),example_redis__)
$(foreach P,env_ arg_,$(call inherit_ctx,docker_redis__$(P),example_redis__$(P)))

example_redis__SERVICE = redis
example_redis__IMAGE = $(DOCKER_REDIS_IMAGE)
example_redis__CONTAINER = $(example_redis__SERVICE)

CTXES += example_redis

example_yaml__SERVICES += .tmp/redis.yaml

########################################################################################################################
# example_pg
########################################################################################################################
$(call inherit_ctx,yaml__,example_pg__)
example_pg__IN = $(TMPL_DIR)/docker/yamls/service.yaml
example_pg__OUT_DIR = $(TMPL_DIR)/docker/yamls/.tmp
example_pg__OUT = $(example_pg__OUT_DIR)/pg.yaml

$(call inherit_vars,docker_pg__,$(INHERIT_VARS),example_pg__)
$(foreach P,env_ arg_,$(call inherit_ctx,docker_pg__$(P),example_pg__$(P)))

example_pg__SERVICE = clickhouse
example_pg__IMAGE = $(DOCKER_PG_IMAGE)
example_pg__CONTAINER = $(example_pg__SERVICE)

CTXES += example_pg

example_yaml__SERVICES += .tmp/pg.yaml

########################################################################################################################
# example_clickhouse
########################################################################################################################
$(call inherit_ctx,yaml__,example_clickhouse__)
example_clickhouse__IN = $(TMPL_DIR)/docker/yamls/service.yaml
example_clickhouse__OUT_DIR = $(TMPL_DIR)/docker/yamls/.tmp
example_clickhouse__OUT = $(example_clickhouse__OUT_DIR)/clickhouse.yaml

$(call inherit_vars,docker_clickhouse__,$(INHERIT_VARS),example_clickhouse__)
$(foreach P,env_ arg_,$(call inherit_ctx,docker_clickhouse__$(P),example_clickhouse__$(P)))

example_clickhouse__SERVICE = clickhouse
example_clickhouse__IMAGE = $(DOCKER_CLICKHOUSE_IMAGE)
example_clickhouse__CONTAINER = $(example_clickhouse__SERVICE)

CTXES += example_clickhouse

example_yaml__SERVICES += .tmp/clickhouse.yaml

########################################################################################################################
# example_rust
########################################################################################################################
$(call inherit_ctx,yaml__,example_rust__)
example_rust__IN = $(TMPL_DIR)/docker/yamls/service.yaml
example_rust__OUT_DIR = $(TMPL_DIR)/docker/yamls/.tmp
example_rust__OUT = $(example_rust__OUT_DIR)/rust.yaml

$(call inherit_vars,docker_rust__,$(INHERIT_VARS),example_rust__)
$(foreach P,env_ arg_,$(call inherit_ctx,docker_rust__$(P),example_rust__$(P)))

example_rust__SERVICE = rust
example_rust__CONTAINER = $(example_rust__SERVICE)

CTXES += example_rust

example_yaml__SERVICES += .tmp/rust.yaml

########################################################################################################################
# example_foo
########################################################################################################################
$(call inherit_ctx,yaml__,example_foo__)
example_foo__IN = $(TMPL_DIR)/docker/yamls/service.yaml
example_foo__OUT_DIR = $(TMPL_DIR)/docker/yamls/.tmp
example_foo__OUT = $(example_foo__OUT_DIR)/foo.yaml

$(call inherit_vars,docker_foo__,$(INHERIT_VARS),example_foo__)
$(foreach P,env_ arg_,$(call inherit_ctx,docker_foo__$(P),example_foo__$(P)))

example_foo__SERVICE = foo
example_foo__CONTAINER = $(example_foo__SERVICE)

CTXES += example_foo

example_yaml__SERVICES += .tmp/foo.yaml

########################################################################################################################
# example_bar
########################################################################################################################
$(call inherit_ctx,yaml__,example_bar__)

example_bar__IN = $(TMPL_DIR)/docker/yamls/service.yaml
example_bar__OUT_DIR = $(TMPL_DIR)/docker/yamls/.tmp
example_bar__OUT = $(example_bar__OUT_DIR)/bar.yaml

$(call inherit_vars,docker_bar__,$(INHERIT_VARS),example_bar__)
$(foreach P,env_ arg_,$(call inherit_ctx,docker_bar__$(P),example_bar__$(P)))

example_bar__SERVICE = bar
example_bar__CONTAINER = $(example_bar__SERVICE)

CTXES += example_bar

example_yaml__SERVICES += .tmp/bar.yaml

########################################################################################################################
# example_yaml
########################################################################################################################
example_yaml__IN = $(TMPL_DIR)/docker/yamls/stand.yaml
example_yaml__OUT_DIR = $(OUTDIR)/docker/compose
example_yaml__OUT = $(example_yaml__OUT_DIR)/example.yaml

example_yaml__BRIDGE = $(example__BRIDGE)
example_yaml__DRIVER = $(example__DRIVER)
example_yaml__SUBNET = $(example__SUBNET)

CTXES += example_yaml
