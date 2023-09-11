# cargo
cargo__ENABLE = $(ENABLE_HOST)
cargo__CARGO_TOML ?= Cargo.toml
cargo__CLIPPY_FORMAT ?= human
cargo__CLIPPY_REPORT ?= &1
cargo__FEATURES ?= 
cargo__LINTS ?= 
cargo__PROFILE ?= dev
cargo__TARGET_ARCH ?= $(rustup__TARGET_ARCH)
cargo__TARGET_DIR ?= target
cargo__INSTALL_DIR ?= $(INSTALL_DIR)
cargo__TAGS = build clean install

# rustup
rustup__ENABLE = $(ENABLE_HOST)
rustup__CRATES ?= \
    cargo-cache__0.8.3 \
    sqlx-cli__0.7.1
rustup__RUST_VERSION ?= 1.71.1
rustup__RUSTFLAGS ?= -C target-feature=-crt-static
rustup__SOURCE_ENV ?= source "$${HOME}/.cargo/env"
rustup__TARGET_ARCH ?= aarch64-apple-darwin
rustup__COMPONENTS = \
    clippy \
    rustfmt
