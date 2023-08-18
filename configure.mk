PWD := $(shell pwd)
RENDER := python3 -m render.main
SHELL := /bin/bash
DEVTOOLS_DIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))

LIB = $(DEVTOOLS_DIR)/lib

# Default vars
include $(DEVTOOLS_DIR)/vars.mk

# Customized vars
ifdef VARS
	# Use '$(shell realpath ...)' because make's $(realpath ...) doesn't expand tilde '~'.
	include $(shell realpath $(VARS))
endif

export OUT_DIR
export TMPL_DIR

.PHONY: all

all:
	$(foreach CTX,$(CTXES),cd $(DEVTOOLS_DIR) && $(RENDER) $(foreach V,$($(CTX)),--$(lastword $(subst |, ,$(V)))='$($(V))') $(LF))
