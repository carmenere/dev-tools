# Includes
include $(ARTEFACTS)/.env.build

### Targets
.PHONY: default env init strip fmt lint unit-tests cargo-build build build_bin clean

default: env

env:
	@echo $(foreach e,$(ENVs),export $(e)=\'$($(e))\'"\n") export ENVs=\'$(ENVs)\'"\n"

$(TARGET_INIT_DIR):
	mkdir -p $(CARGO_ARTEFACTS_DIR)
	touch $@

init: $(TARGET_INIT_DIR)

strip:
ifeq ($(BUILD_MODE),release)
	strip $(BIN_PATH)
endif

fmt:
	cargo fmt --all --manifest-path $(CARGO_TOML) -- --check

lint:
	cargo clippy $(BUILD_OPTs) --bin $(BUILD_BIN_NAME) --manifest-path $(CARGO_TOML) --target-dir $(CARGO_ARTEFACTS_DIR) --target $(BUILD_TARGET_ARCH) -- -D warnings

unit-tests:
	cargo test $(BUILD_OPTs) --bin $(BUILD_BIN_NAME) --manifest-path $(CARGO_TOML) --target-dir $(CARGO_ARTEFACTS_DIR) --target $(BUILD_TARGET_ARCH)

cargo-build: fmt lint unit-tests
	cargo build $(BUILD_OPTs) --bin $(BUILD_BIN_NAME) --manifest-path $(CARGO_TOML) --target-dir $(CARGO_ARTEFACTS_DIR) --target $(BUILD_TARGET_ARCH)

$(BIN_PATH): $(ASSET_FILES)
	$(MAKE) -f $(MK)/cargo.mk init
	$(MAKE) -f $(MK)/cargo.mk cargo-build
	$(MAKE) -f $(MK)/cargo.mk strip

build: $(BIN_PATH)

run:
	$(BIN_PATH)

clean:
	cargo clean --manifest-path $(CARGO_TOML)
	[ ! -d $(CARGO_ARTEFACTS_DIR) ] || rm -Rfv $(CARGO_ARTEFACTS_DIR)/*