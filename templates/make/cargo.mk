TOPDIR := {{ TOPDIR }}
LIB := {{ LIB }}

include $(LIB)/common.mk

BINS ?= {{ BINS }}
BINS_DIR ?= {{ BINS_DIR }}
CARGO_TOML ?= {{ TOML }}
CLIPPY_FORMAT ?= {{ CLIPPY_FORMAT }}
CLIPPY_REPORT ?= {{ CLIPPY_REPORT }}
FEATURES ?= {{ FEATURES }}
INSTALL_DIR ?= {{ INSTALL_DIR }}
LINTS ?= {{ LINTS }}
PROFILE ?= {{ PROFILE }}
PROFILE_DIR ?= {{ PROFILE_DIR }}
TARGET_ARCH ?= {{ TARGET_ARCH }}
TARGET_DIR ?= {{ TARGET_DIR }}

{% set e = [] -%}
{% if ENVS -%}
{% for item in ENVS.split(' ') -%}
{{ item }} = {{ env[item] }}
{% endfor -%}
{% for item in ENVS.split(' ') -%}
{% do e.append("{}=$({})".format(item, item)) -%}
{% endfor -%}
{% endif -%}

{% if e %}
ENVS ?= \
    {{ e|join(' \\\n    ') }}
{% endif %}
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

install:
ifdef BINS
	install -d $(INSTALL_DIR)
	$(foreach BIN,$(BINS),install -m 755 -t $(INSTALL_DIR) $(BINS_DIR)/$(BIN) ${LF})
endif

uninstall:
ifdef BINS
	$(foreach BIN,$(BINS),rm $(INSTALL_DIR)/$(BIN))
endif

clean:
	$(CMD_CLEAN)

distclean: clean
