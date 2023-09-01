SELFDIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))

DEVTOOLS_DIR := {{ DEVTOOLS_DIR }}

include $(DEVTOOLS_DIR)/configure/defaults.mk
include $(DEVTOOLS_DIR)/templates/make/common/lib.mk

include {{ SETTINGS }}

{% if CARGO_TOML is defined and CARGO_TOML.replace('"', '').replace("'",'') != '' -%}
CARGO_TOML ?= {{ CARGO_TOML }}
{% else %}
{% include 'CARGO_TOML is required and cannot be empty string.' %}
{% endif -%}

BINS ?= {{ BINS | default('', true) }}
CLIPPY_FORMAT ?= {{ CLIPPY_FORMAT | default('human', true) }}
CLIPPY_REPORT ?= {{ CLIPPY_REPORT | default('&1', true) }}
FEATURES ?= {{ FEATURES | default('', true) }}
LINTS ?= {{ LINTS | default('', true) }}
PROFILE ?= {{ PROFILE | default('$(d__CARGO_PROFILE)', true) }}
TARGET_ARCH ?= {{ TARGET_ARCH | default('$(d__RUST_TARGET_ARCH)', true) }}
TARGET_DIR ?= {{ TARGET_DIR | default('$(d__CARGO_TARGET_DIR)', true) }}

# ENVS
{% include 'common/j2/envs.jinja2' %}

# OPT_BINS
ifdef BINS
    OPT_BINS = $(foreach BIN,$(BINS), --bin $(BIN))
else
    OPT_BINS = --bins
endif

# OPT_PROFILE
ifeq ($(PROFILE),release)
    OPT_PROFILE = --profile release
else
    OPT_PROFILE = --profile dev
endif

# OPT_FEATURES
ifdef FEATURES
    OPT_FEATURES = --features $(FEATURES)
else
    OPT_FEATURES =
endif

# CARGO_OPTS
CARGO_OPTS ?= $(OPT_PROFILE) $(OPT_BINS) $(OPT_FEATURES) --manifest-path $(CARGO_TOML) \
    --target-dir $(TARGET_DIR) \
    --target $(TARGET_ARCH)

CMD_BUILD ?=  $(ENVS) cargo build $(CARGO_OPTS)
CMD_CLIPPY ?= $(ENVS) cargo clippy $(CARGO_OPTS) --message-format $(CLIPPY_FORMAT) -- $(LINTS) 1>$(CLIPPY_REPORT)
CMD_TEST ?= $(ENVS) cargo test $(CARGO_OPTS)
CMD_CLEAN ?= $(ENVS) cargo clean --manifest-path $(CARGO_TOML)
CMD_FMT ?= $(ENVS) cargo fmt --all --manifest-path $(CARGO_TOML)

.PHONY: all build clippy test fmt fmt-check install uninstall clean distclean

all: fmt clippy build test

build:
	$(CMD_BUILD)

clippy:
	$(CMD_CLIPPY)

test:
	$(CMD_TEST)

fmt:
	$(CMD_FMT)

fmt-check:
	$(CMD_FMT) -- --check

clean:

distclean: 
	$(CMD_CLEAN)