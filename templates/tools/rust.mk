TOPDIR := {{ TOPDIR | default('$(shell pwd)', true) }}

TARGET_ARCH ?= {{ TARGET_ARCH | default('aarch64-apple-darwin', true) }}
RUST_VERSION ?= {{ RUST_VERSION | default('1.71.1', true) }}
SQLX_VERSION ?= {{ SQLX_VERSION | default('0.7.1', true) }}
RUSTFLAGS ?= {{ RUSTFLAGS | default('-C target-feature=-crt-static', true) }}

rustup:
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain $(RUST_VERSION)-$(TARGET_ARCH)

default:
	rustup default $(RUST_VERSION)-$(TARGET_ARCH)

components:
	source "$${HOME}/.cargo/env" && \
		rustup component add clippy rustfmt

tools:
	source "$${HOME}/.cargo/env" && \
		cargo install --target=$(TARGET_ARCH) --version=$(SQLX_VERSION) --force sqlx-cli

all: rustup default components tools
