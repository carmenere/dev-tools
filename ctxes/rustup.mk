########################################################################################################################
# rustup
########################################################################################################################
rustup__IN = $(TMPL_DIR)/rust/rustup.mk
rustup__OUT_DIR = $(OUTDIR)/rust
rustup__OUT = $(rustup__OUT_DIR)/rustup.mk

rustup__CRATES += cargo-cache__0.8.3
rustup__CRATES += sqlx-cli__0.7.1

CTXES += rustup
