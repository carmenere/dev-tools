WITH_PYTHON = yes

ifeq ($(WITH_PYTHON),yes)
include $(DEVTOOLS_DIR)/toolchain/python/defaults.mk
endif
