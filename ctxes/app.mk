########################################################################################################################
# alembic_baz
########################################################################################################################
ENABLE_CTX_alembic_baz = $(ENABLE_ALL_CTXES)
TAG_alembic_baz = clean host_schema

alembic_baz__APP = alembic_baz

alembic_baz__IN = $(MK)/app.mk
alembic_baz__OUT_DIR = $(OUTDIR)/app/alembic/baz
alembic_baz__OUT = $(alembic_baz__OUT_DIR)/Makefile

alembic_baz__BIN_PATH = $(BASH) -c 'echo "just for test"'
alembic_baz__TMUX = $(tmux__OUT)

# alembic envs
# $1:SCHEMA $2:USER; $3:PASSWORD, $4:HOST, $5:PORT, $6:DB
alembic_baz__env_DATABASE_URL = $(call conn_url,,$(psql_baz__USER_NAME),$(psql_baz__USER_PASSWORD),,,$(psql_baz__USER_DB))

CTXES += alembic_baz

########################################################################################################################
# sqlx_bar
########################################################################################################################
ENABLE_CTX_sqlx_bar = $(ENABLE_ALL_CTXES)
TAG_sqlx_bar = clean host_schema

sqlx_bar__APP = sqlx_bar

sqlx_bar__IN = $(MK)/app.mk
sqlx_bar__OUT_DIR = $(OUTDIR)/app/sqlx/bar
sqlx_bar__OUT = $(sqlx_bar__OUT_DIR)/Makefile

sqlx_bar__BIN_PATH = sqlx migrate run
sqlx_bar__TMUX = $(tmux__OUT)

# sqlx envs
sqlx_bar__env_DATABASE_URL = $(call conn_url,,$(psql_bar__USER_NAME),$(psql_bar__USER_PASSWORD),,,$(psql_bar__USER_DB))

# cli opts
sqlx_bar__opt_SOURCE = --source "$(PROJECT_ROOT)/examples/bar/$(SCHEMAS_DIR)"

CTXES += sqlx_bar

########################################################################################################################
# sqlx_foo
########################################################################################################################
ENABLE_CTX_sqlx_foo = $(ENABLE_ALL_CTXES)
TAG_sqlx_foo = clean host_schema

sqlx_foo__APP = sqlx_foo

sqlx_foo__IN = $(MK)/app.mk
sqlx_foo__OUT_DIR = $(OUTDIR)/app/sqlx/foo
sqlx_foo__OUT = $(sqlx_foo__OUT_DIR)/Makefile

sqlx_foo__BIN_PATH = sqlx migrate run
sqlx_foo__TMUX = $(tmux__OUT)

# sqlx envs
sqlx_foo__env_DATABASE_URL = $(call conn_url,,$(psql_foo__USER_NAME),$(psql_foo__USER_PASSWORD),,,$(psql_foo__USER_DB))

# cli opts
sqlx_foo__opt_SOURCE = --source "$(PROJECT_ROOT)/examples/foo/$(SCHEMAS_DIR)"

CTXES += sqlx_foo

########################################################################################################################
# foo
########################################################################################################################
ENABLE_CTX_foo = $(ENABLE_ALL_CTXES)
TAG_foo = clean host_app

foo__APP = foo

foo__IN = $(MK)/app.mk
foo__OUT_DIR = $(OUTDIR)/app/$(foo__APP)
foo__OUT = $(foo__OUT_DIR)/Makefile

foo__BIN_PATH = $(call cargo_bins,dev,$(CARGO_TARGET_DIR),$(RUST_TARGET_ARCH))/foo
foo__MODE = tmux
foo__TMUX = $(tmux__OUT)

# foo envs
foo__env_RUST_LOG = $(foo__APP)=debug

CTXES += foo

########################################################################################################################
# bar
########################################################################################################################
ENABLE_CTX_bar = $(ENABLE_ALL_CTXES)
TAG_bar = clean host_app

bar__APP = bar

bar__IN = $(MK)/app.mk
bar__OUT_DIR = $(OUTDIR)/app/$(bar__APP)
bar__OUT = $(bar__OUT_DIR)/Makefile

bar__BIN_PATH = $(call cargo_bins,dev,$(CARGO_TARGET_DIR),$(RUST_TARGET_ARCH))/bar
bar__MODE = tee
bar__TMUX = $(tmux__OUT)

# bar envs
bar__env_RUST_LOG = $(bar__APP)=debug

CTXES += bar
