########################################################################################################################
# sqlx_bar
########################################################################################################################
ENABLE_sqlx_bar = $(ENABLE_SCHEMAS)
sqlx_bar__STAGE = schemas

sqlx_bar__APP = sqlx_bar

sqlx_bar__IN = $(MK)/app.mk
sqlx_bar__OUT_DIR = $(OUTDIR)/app/sqlx/bar
sqlx_bar__OUT = $(sqlx_bar__OUT_DIR)/Makefile

sqlx_bar__BIN_PATH = sqlx migrate run
sqlx_bar__TMUX = $(tmux__OUT)

# sqlx envs
sqlx_bar__env_DATABASE_URL = $(call pg_db_url,,,,,bar)

# cli opts
sqlx_bar__opt_SOURCE = --source "$(PROJECT_ROOT)/examples/bar/$(SCHEMAS_DIR)"

CTXES += sqlx_bar

########################################################################################################################
# sqlx_foo
########################################################################################################################
ENABLE_sqlx_foo = $(ENABLE_SCHEMAS)
sqlx_foo__STAGE = schemas

sqlx_foo__APP = sqlx_foo

sqlx_foo__IN = $(MK)/app.mk
sqlx_foo__OUT_DIR = $(OUTDIR)/app/sqlx/foo
sqlx_foo__OUT = $(sqlx_foo__OUT_DIR)/Makefile

sqlx_foo__BIN_PATH = sqlx migrate run
sqlx_foo__TMUX = $(tmux__OUT)

# sqlx envs
sqlx_foo__env_DATABASE_URL = $(call pg_db_url,,,,,foo)

# cli opts
sqlx_foo__opt_SOURCE = --source "$(PROJECT_ROOT)/examples/foo/$(SCHEMAS_DIR)"

CTXES += sqlx_foo

########################################################################################################################
# foo
########################################################################################################################
ENABLE_foo = $(ENABLE_HOST_APPS)
foo__STAGE = apps

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
ENABLE_bar = $(ENABLE_HOST_APPS)
bar__STAGE = apps

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
