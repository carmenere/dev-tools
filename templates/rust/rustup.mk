SELF := $(realpath $(lastword $(MAKEFILE_LIST)))
DEVTOOLS_DIR := {{ DEVTOOLS_DIR }}

include $(DEVTOOLS_DIR)/lib.mk

CRATES ?= {{ CRATES }}
RUST_VERSION ?= {{ RUST_VERSION }}
RUSTFLAGS ?= {{ RUSTFLAGS }}
SOURCE_ENV ?= {{ SOURCE_ENV }}
TARGET_ARCH ?= {{ TARGET_ARCH }}

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
