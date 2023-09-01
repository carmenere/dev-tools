########################################################################################################################
CTX := cargo_foo
########################################################################################################################
ctx_cargo_foo__ENABLED = yes
ctx_cargo_foo__STAGE = build

cargo_foo__IN = $(MK)/cargo.mk
cargo_foo__OUT_DIR = $(d__OUTDIR)/cargo/foo
cargo_foo__OUT = $(cargo_foo__OUT_DIR)/Makefile

cargo_foo__BINS = foo
cargo_foo__CARGO_TOML = $(d__PROJECT_ROOT)/examples/foo/Cargo.toml

# cargo envs
cargo_foo__env_RUSTFLAGS = $(d__RUSTFLAGS)
cargo_foo__env_BUILD_VERSION = $(d__BUILD_VERSION)

cargo_foo__ENVS = $(call list_by_prefix,cargo_foo__env_)

CTXES := $(CTXES) cargo_foo

########################################################################################################################
CTX := cargo_bar
########################################################################################################################
ctx_cargo_bar__ENABLED = yes
ctx_cargo_bar__STAGE = build

cargo_bar__IN = $(MK)/cargo.mk
cargo_bar__OUT_DIR = $(d__OUTDIR)/cargo/bar
cargo_bar__OUT = $(cargo_bar__OUT_DIR)/Makefile

cargo_bar__BINS = bar
cargo_bar__CARGO_TOML = $(d__PROJECT_ROOT)/examples/bar/Cargo.toml

$(call copy,cargo_foo__env_,cargo_bar__env_)
cargo_bar__env_DATABASE_URL = $(d__PG_DATABASE_URL)

cargo_bar__ENVS = $(call list_by_prefix,cargo_bar__env_)

CTXES := $(CTXES) cargo_bar