########################################################################################################################
# cargo_foo
########################################################################################################################
$(call inherit_ctx,cargo__,cargo_foo__)

cargo_foo__IN = $(TMPL_DIR)/rust/cargo.mk
cargo_foo__OUT_DIR = $(OUTDIR)/cargo
cargo_foo__OUT = $(cargo_foo__OUT_DIR)/foo.mk

cargo_foo__BINS = foo
cargo_foo__CARGO_TOML = $(PROJECT_ROOT)/examples/foo/Cargo.toml

# cargo envs
cargo_foo__env_RUSTFLAGS = $(RUSTFLAGS)
cargo_foo__env_BUILD_VERSION = $(BUILD_VERSION)
cargo_foo__env_DATABASE_URL = $(call conn_url,psql_foo,postgres,,,,)

CTXES += cargo_foo

########################################################################################################################
# cargo_bar
########################################################################################################################
$(call inherit_ctx,cargo__,cargo_bar__)

cargo_bar__IN = $(TMPL_DIR)/rust/cargo.mk
cargo_bar__OUT_DIR = $(OUTDIR)/cargo
cargo_bar__OUT = $(cargo_bar__OUT_DIR)/bar.mk

cargo_bar__BINS = bar
cargo_bar__CARGO_TOML = $(PROJECT_ROOT)/examples/bar/Cargo.toml

$(call copy_ctx,cargo_foo__env_,cargo_bar__env_)
cargo_bar__env_DATABASE_URL = $(call conn_url,psql_bar,postgres,,,,)

CTXES += cargo_bar
