########################################################################################################################
# alembic_baz
########################################################################################################################
$(call inherit_ctx,app__,alembic_baz__)
alembic_baz__TAGS = clean schema

alembic_baz__APP = alembic_baz

alembic_baz__IN = $(TMPL_DIR)/app.mk
alembic_baz__OUT_DIR = $(OUTDIR)/app/alembic
alembic_baz__OUT = $(alembic_baz__OUT_DIR)/baz.mk

alembic_baz__BIN_PATH = $(BASH) -c 'echo "just for test"'

# alembic envs
# $1:SCHEMA $2:USER; $3:PASSWORD, $4:HOST, $5:PORT, $6:DB
alembic_baz__env_DATABASE_URL = $(call conn_url,psql_baz,postgres,,,,)

CTXES += alembic_baz

########################################################################################################################
# sqlx_bar
########################################################################################################################
$(call inherit_ctx,app__,sqlx_bar__)
sqlx_bar__TAGS = clean schema

sqlx_bar__APP = sqlx_bar

sqlx_bar__IN = $(TMPL_DIR)/app.mk
sqlx_bar__OUT_DIR = $(OUTDIR)/app/sqlx
sqlx_bar__OUT = $(sqlx_bar__OUT_DIR)/bar.mk

sqlx_bar__BIN_PATH = sqlx migrate run

# sqlx envs
sqlx_bar__env_DATABASE_URL = $(call conn_url,psql_bar,postgres,,,,)

# cli opts
sqlx_bar__opt_SOURCE = --source "$(PROJECT_ROOT)/examples/bar/$(SCHEMAS_DIR)"

CTXES += sqlx_bar

########################################################################################################################
# sqlx_foo
########################################################################################################################
$(call inherit_ctx,app__,sqlx_foo__)
sqlx_foo__TAGS = clean schema

sqlx_foo__APP = sqlx_foo

sqlx_foo__IN = $(TMPL_DIR)/app.mk
sqlx_foo__OUT_DIR = $(OUTDIR)/app/sqlx
sqlx_foo__OUT = $(sqlx_foo__OUT_DIR)/foo.mk

sqlx_foo__BIN_PATH = sqlx migrate run

# sqlx envs
sqlx_foo__env_DATABASE_URL = $(call conn_url,psql_foo,postgres,,,,)

# cli opts
sqlx_foo__opt_SOURCE = --source "$(PROJECT_ROOT)/examples/foo/$(SCHEMAS_DIR)"

CTXES += sqlx_foo

########################################################################################################################
# foo
########################################################################################################################
$(call inherit_ctx,app__,foo__)

foo__APP = foo

foo__IN = $(TMPL_DIR)/app.mk
foo__OUT_DIR = $(OUTDIR)/app
foo__OUT = $(foo__OUT_DIR)/$(foo__APP).mk

foo__BIN_PATH = $(call cargo_bins,dev,$(cargo__TARGET_DIR),$(cargo__TARGET_ARCH))/foo
foo__MODE = tmux

# foo envs
foo__env_RUST_LOG = $(foo__APP)=debug

CTXES += foo

########################################################################################################################
# bar
########################################################################################################################
$(call inherit_ctx,app__,bar__)

bar__APP = bar

bar__IN = $(TMPL_DIR)/app.mk
bar__OUT_DIR = $(OUTDIR)/app
bar__OUT = $(bar__OUT_DIR)/$(bar__APP).mk

bar__BIN_PATH = $(call cargo_bins,dev,$(cargo__TARGET_DIR),$(cargo__TARGET_ARCH))/bar
bar__MODE = tee

# bar envs
bar__env_RUST_LOG = $(bar__APP)=debug

CTXES += bar
