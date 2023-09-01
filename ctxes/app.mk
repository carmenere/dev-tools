########################################################################################################################
CTX := app_sqlx_bar
########################################################################################################################
ctx_app_sqlx_bar__ENABLED = yes
ctx_app_sqlx_bar__STAGE = schemas

app_sqlx_bar__APP = sqlx_bar

app_sqlx_bar__IN = $(MK)/app.mk
app_sqlx_bar__OUT_DIR = $(d__OUTDIR)/app/sqlx/bar
app_sqlx_bar__OUT = $(app_sqlx_bar__OUT_DIR)/Makefile

app_sqlx_bar__BIN_PATH = sqlx migrate run
app_sqlx_bar__OPTS = --source "$(d__PROJECT_ROOT)/examples/bar/$(SCHEMAS_DIR)"
app_sqlx_bar__TMUX = $(tmux__OUT)

# sqlx envs
app_sqlx_bar__env_DATABASE_URL = $(d__PG_DATABASE_URL)

app_sqlx_bar__ENVS = $(call list_by_prefix,app_sqlx_bar__env_)

CTXES := $(CTXES) app_sqlx_bar

########################################################################################################################
CTX := app_foo
########################################################################################################################
ctx_app_foo__ENABLED = $(d__HOST_APPS_ENABLED)
ctx_app_foo__STAGE = apps

app_foo__APP = foo

app_foo__IN = $(MK)/app.mk
app_foo__OUT_DIR = $(d__OUTDIR)/app/$(app_foo__APP)
app_foo__OUT = $(app_foo__OUT_DIR)/Makefile

app_foo__BIN_PATH = $(call cargo_bins,dev,$(d__CARGO_TARGET_DIR),$(d__RUST_TARGET_ARCH))/foo
app_foo__MODE = tmux
app_foo__TMUX = $(tmux__OUT)

# foo envs
app_foo__env_RUST_LOG = $(app_foo__APP)=debug

app_foo__ENVS = $(call list_by_prefix,app_foo__env_)

CTXES := $(CTXES) app_foo

########################################################################################################################
CTX := app_bar
########################################################################################################################
ctx_app_bar__ENABLED = $(d__HOST_APPS_ENABLED)
ctx_app_bar__STAGE = apps

app_bar__APP = bar

app_bar__IN = $(MK)/app.mk
app_bar__OUT_DIR = $(d__OUTDIR)/app/$(app_bar__APP)
app_bar__OUT = $(app_bar__OUT_DIR)/Makefile

app_bar__BIN_PATH = $(call cargo_bins,dev,$(d__CARGO_TARGET_DIR),$(d__RUST_TARGET_ARCH))/bar
app_bar__MODE = tee
app_bar__TMUX = $(tmux__OUT)

# bar envs
app_bar__env_RUST_LOG = $(app_bar__APP)=debug

app_bar__ENVS = $(call list_by_prefix,app_bar__env_)

CTXES := $(CTXES) app_bar
