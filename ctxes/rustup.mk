########################################################################################################################
# rustup
########################################################################################################################
rustup__IN = $(MK)/rustup.mk
rustup__OUT_DIR = $(d__OUTDIR)/rustup
rustup__OUT = $(rustup__OUT_DIR)/Makefile

CRATES += cargo-cache
rustup__CARGO_CACHE_VERSION = 0.8.3

CRATES += sqlx-cli
rustup__SQLX_CLI_VERSION = 0.7.1

CTXES += rustup
