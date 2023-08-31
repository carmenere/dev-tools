{% import "common/defaults.j2" as d %}
SELFDIR := {{ SELFDIR | default(d.SELFDIR, true) }}

CRATES ?= {{ CRATES | default('cargo-cache sqlx-cli', true) }}
RUST_VERSION ?= {{ RUST_VERSION | default(d.RUST_VERSION, true) }}
RUSTFLAGS ?= {{ RUSTFLAGS | default(d.RUSTFLAGS, true) }}
SOURCE_ENV ?= {{ SOURCE_ENV | default('source "$${HOME}/.cargo/env"', true) }}
TARGET_ARCH ?= {{ TARGET_ARCH | default(d.RUST_TARGET_ARCH, true) }}

CARGO_CACHE_VERSION = 0.8.3
SQLX_CLI_VERSION = 0.7.1

COMPONENTS += clippy
COMPONENTS += rustfmt

{% include 'common/lib.mk' %}

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

clean:

distclean:

# Create migrations in current dir (.): sqlx migrate add --source . init
# Clean: cargo cache -r all
# Show: cargo cache -i
