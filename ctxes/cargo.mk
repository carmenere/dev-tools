########################################################################################################################
# cargo_foo
########################################################################################################################
ENABLE_cargo_foo = $(ENABLE_CARGO)
cargo_foo__STAGE = cargo install uninstall

cargo_foo__IN = $(MK)/cargo.mk
cargo_foo__OUT_DIR = $(OUTDIR)/cargo/foo
cargo_foo__OUT = $(cargo_foo__OUT_DIR)/Makefile

cargo_foo__BINS = foo
cargo_foo__CARGO_TOML = $(PROJECT_ROOT)/examples/foo/Cargo.toml

# cargo envs
cargo_foo__env_RUSTFLAGS = $(RUSTFLAGS)
cargo_foo__env_BUILD_VERSION = $(BUILD_VERSION)
cargo_foo__env_DATABASE_URL = $(call pg_db_url,,,,,foo)

CTXES += cargo_foo

########################################################################################################################
# cargo_bar
########################################################################################################################
ENABLE_cargo_bar = $(ENABLE_CARGO)
cargo_bar__STAGE = cargo install uninstall

cargo_bar__IN = $(MK)/cargo.mk
cargo_bar__OUT_DIR = $(OUTDIR)/cargo/bar
cargo_bar__OUT = $(cargo_bar__OUT_DIR)/Makefile

cargo_bar__BINS = bar
cargo_bar__CARGO_TOML = $(PROJECT_ROOT)/examples/bar/Cargo.toml

$(call copy_ctx,cargo_foo__env_,cargo_bar__env_)
cargo_bar__env_DATABASE_URL = $(call pg_db_url,,,,,bar)

CTXES += cargo_bar
