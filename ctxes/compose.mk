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
example__IN = $(MK)/compose.mk
example__OUT_DIR = $(d__OUTDIR)/compose
example__OUT = $(example__OUT_DIR)/example.mk
example__BRIDGE = $(d__DOCKER_NETWORK_NAME)
example__DRIVER = $(d__DOCKER_NETWORK_DRIVER)
example__SUBNET = $(d__DOCKER_NETWORK_SUBNET)

CTXES += example

########################################################################################################################
# example_redis
########################################################################################################################
example_redis__IN = $(TMPL_DIR)/compose/service.yaml
example_redis__OUT_DIR = $(TMPL_DIR)/compose/.tmp
example_redis__OUT = $(example_redis__OUT_DIR)/redis.yaml

$(call inherit_vars,docker_redis__,$(INHERIT_VARS),example_redis__)
$(foreach P,env_ arg_,$(call inherit_ctx,docker_redis__$(P),example_redis__$(P)))

example_redis__SERVICE = redis

CTXES += example_redis

example_yaml__SERVICES += .tmp/redis.yaml

########################################################################################################################
# example_pg
########################################################################################################################
example_pg__IN = $(TMPL_DIR)/compose/service.yaml
example_pg__OUT_DIR = $(TMPL_DIR)/compose/.tmp
example_pg__OUT = $(example_pg__OUT_DIR)/pg.yaml

$(call inherit_vars,docker_pg__,$(INHERIT_VARS),example_pg__)
$(foreach P,env_ arg_,$(call inherit_ctx,docker_pg__$(P),example_pg__$(P)))

example_pg__SERVICE = pg

CTXES += example_pg

example_yaml__SERVICES += .tmp/pg.yaml

########################################################################################################################
# example_clickhouse
########################################################################################################################
example_clickhouse__IN = $(TMPL_DIR)/compose/service.yaml
example_clickhouse__OUT_DIR = $(TMPL_DIR)/compose/.tmp
example_clickhouse__OUT = $(example_clickhouse__OUT_DIR)/clickhouse.yaml

$(call inherit_vars,docker_clickhouse__,$(INHERIT_VARS),example_clickhouse__)
$(foreach P,env_ arg_,$(call inherit_ctx,docker_clickhouse__$(P),example_clickhouse__$(P)))

example_clickhouse__SERVICE = clickhouse

CTXES += example_clickhouse

example_yaml__SERVICES += .tmp/clickhouse.yaml

########################################################################################################################
# example_rust
########################################################################################################################
example_rust__IN = $(TMPL_DIR)/compose/service.yaml
example_rust__OUT_DIR = $(TMPL_DIR)/compose/.tmp
example_rust__OUT = $(example_rust__OUT_DIR)/rust.yaml

$(call inherit_vars,docker_rust__,$(INHERIT_VARS),example_rust__)
$(foreach P,env_ arg_,$(call inherit_ctx,docker_rust__$(P),example_rust__$(P)))

example_rust__SERVICE = rust

CTXES += example_rust

example_yaml__SERVICES += .tmp/rust.yaml

########################################################################################################################
# example_foo
########################################################################################################################
example_foo__IN = $(TMPL_DIR)/compose/service.yaml
example_foo__OUT_DIR = $(TMPL_DIR)/compose/.tmp
example_foo__OUT = $(example_foo__OUT_DIR)/foo.yaml

$(call inherit_vars,docker_foo__,$(INHERIT_VARS),example_foo__)
$(foreach P,env_ arg_,$(call inherit_ctx,docker_foo__$(P),example_foo__$(P)))

example_foo__SERVICE = foo

CTXES += example_foo

example_yaml__SERVICES += .tmp/foo.yaml

########################################################################################################################
# example_bar
########################################################################################################################
example_bar__IN = $(TMPL_DIR)/compose/service.yaml
example_bar__OUT_DIR = $(TMPL_DIR)/compose/.tmp
example_bar__OUT = $(example_bar__OUT_DIR)/bar.yaml

$(call inherit_vars,docker_bar__,$(INHERIT_VARS),example_bar__)
$(foreach P,env_ arg_,$(call inherit_ctx,docker_bar__$(P),example_bar__$(P)))

example_bar__SERVICE = bar

CTXES += example_bar

example_yaml__SERVICES += .tmp/bar.yaml

########################################################################################################################
# example_yaml
########################################################################################################################
example_yaml__IN = $(TMPL_DIR)/compose/stand.yaml
example_yaml__OUT_DIR = $(d__OUTDIR)/compose
example_yaml__OUT = $(example_yaml__OUT_DIR)/example.yaml

CTXES += example_yaml
