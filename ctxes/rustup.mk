########################################################################################################################
# rustup
########################################################################################################################
rustup__IN = $(MK)/rustup.mk
rustup__OUT_DIR = $(OUTDIR)/rustup
rustup__OUT = $(rustup__OUT_DIR)/Makefile

rustup__CRATES += cargo-cache__0.8.3
rustup__CRATES += sqlx-cli__0.7.1

CTXES += rustup
