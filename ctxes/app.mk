########################################################################################################################
# sqlx_bar
########################################################################################################################
ctx_sqlx_bar__ENABLED = no
ctx_sqlx_bar__STAGE = schemas

sqlx_bar__APP = sqlx_bar

sqlx_bar__IN = $(MK)/app.mk
sqlx_bar__OUT_DIR = $(d__OUTDIR)/app/sqlx/bar
sqlx_bar__OUT = $(sqlx_bar__OUT_DIR)/Makefile

sqlx_bar__BIN_PATH = sqlx migrate run
sqlx_bar__OPTS = --source "$(d__PROJECT_ROOT)/examples/bar/$(d__SCHEMAS_DIR)"
sqlx_bar__TMUX = $(tmux__OUT)

# sqlx envs
sqlx_bar__env_DATABASE_URL = $(d__PG_DATABASE_URL)

CTXES += sqlx_bar

########################################################################################################################
# foo
########################################################################################################################
ctx_foo__ENABLED = no
ctx_foo__STAGE = apps

foo__APP = foo

foo__IN = $(MK)/app.mk
foo__OUT_DIR = $(d__OUTDIR)/app/$(foo__APP)
foo__OUT = $(foo__OUT_DIR)/Makefile

foo__BIN_PATH = $(call cargo_bins,dev,$(d__CARGO_TARGET_DIR),$(d__RUST_TARGET_ARCH))/foo
foo__MODE = tmux
foo__TMUX = $(tmux__OUT)

# foo envs
foo__env_RUST_LOG = $(foo__APP)=debug

CTXES += foo

########################################################################################################################
# bar
########################################################################################################################
ctx_bar__ENABLED = no
ctx_bar__STAGE = apps

bar__APP = bar

bar__IN = $(MK)/app.mk
bar__OUT_DIR = $(d__OUTDIR)/app/$(bar__APP)
bar__OUT = $(bar__OUT_DIR)/Makefile

bar__BIN_PATH = $(call cargo_bins,dev,$(d__CARGO_TARGET_DIR),$(d__RUST_TARGET_ARCH))/bar
bar__MODE = tee
bar__TMUX = $(tmux__OUT)

# bar envs
bar__env_RUST_LOG = $(bar__APP)=debug

CTXES += bar
