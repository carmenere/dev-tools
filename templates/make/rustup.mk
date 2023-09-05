SELFDIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
DEVTOOLS_DIR := {{ DEVTOOLS_DIR }}

include $(DEVTOOLS_DIR)/lib.mk

CRATES ?= {{ CRATES | default('cargo-cache__0.8.3 sqlx-cli__0.7.1', true) }}
RUST_VERSION ?= {{ RUST_VERSION | default(d['RUST_VERSION'], true) }}
RUSTFLAGS ?= {{ RUSTFLAGS | default(d['RUSTFLAGS'], true) }}
SOURCE_ENV ?= {{ SOURCE_ENV | default('source "$${HOME}/.cargo/env"', true) }}
TARGET_ARCH ?= {{ TARGET_ARCH | default(d['RUST_TARGET_ARCH'], true) }}

COMPONENTS += clippy
COMPONENTS += rustfmt

.PHONY: all rustup default components install clean-cache

all: rustup default components install clean-cache

rustup:
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain $(RUST_VERSION)-$(TARGET_ARCH)

default:
	$(SOURCE_ENV) && rustup default $(RUST_VERSION)-$(TARGET_ARCH)

components:
	$(SOURCE_ENV) && rustup component add $(COMPONENTS)

install: 
	$(foreach CRATE,$(CRATES),$(SOURCE_ENV) && \
		RUSTFLAGS='$(RUSTFLAGS)' cargo install --target=$(TARGET_ARCH) --version=$(lastword $(subst __, ,$(CRATE))) --force $(firstword $(subst __, ,$(CRATE))) \
	$(LF))

clean:

distclean:

# Create migrations in current dir (.): sqlx migrate add --source . init
# Clean: cargo cache -r all
# Show: cargo cache -i
