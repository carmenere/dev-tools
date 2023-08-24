TOPDIR := {{ TOPDIR }}

TARGET_ARCH ?= {{ TARGET_ARCH }}
RUST_VERSION ?= {{ RUST_VERSION }}
SQLX_VERSION ?= {{ SQLX_VERSION }}
RUSTFLAGS ?= {{ RUSTFLAGS }}

rustup:
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain $(RUST_VERSION)-$(TARGET_ARCH)

default:
	source "$${HOME}/.cargo/env" && \
	rustup default $(RUST_VERSION)-$(TARGET_ARCH)

components:
	source "$${HOME}/.cargo/env" && \
		rustup component add clippy rustfmt

tools:
	source "$${HOME}/.cargo/env" && \
		cargo install --target=$(TARGET_ARCH) --version=$(SQLX_VERSION) --force sqlx-cli

all: rustup default components tools

# Create migrations in current dir:
#   sqlx migrate add --source . init