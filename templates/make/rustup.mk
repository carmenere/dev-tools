TOPDIR := $(shell pwd)

LIB := {{ LIB }}
include $(LIB)/common.mk

SOURCE_ENV = source "$${HOME}/.cargo/env"

TARGET_ARCH ?= {{ TARGET_ARCH }}
RUST_VERSION ?= {{ RUST_VERSION }}
SQLX_CLI_VERSION ?= {{ SQLX_VERSION }}
CARGO_CACHE_VERSION ?= {{ CARGO_CACHE_VERSION }}
RUSTFLAGS ?= {{ RUSTFLAGS }}

CARGO_CACHE ?= {{ CARGO_CACHE }}
SQLX ?= {{ SQLX }}

# It isn't installed by default
ifeq ($(CARGO_CACHE),yes)
CRATES += cargo-cache
endif

# It installed by default
ifneq ($(SQLX),no)
CRATES += sqlx-cli
endif

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
		cargo install --target=$(TARGET_ARCH) --version=$($(call uppercase,$(subst -,_,$(CRATE)))_VERSION) --force $(CRATE) \
	$(LF))

clean-cache:
ifeq ($(CARGO_CACHE),yes)
	$(SOURCE_ENV) && cargo cache -r all
endif

# Create migrations in current dir (.): sqlx migrate add --source . init
# Clean: cargo cache -r all
# Show: cargo cache -i