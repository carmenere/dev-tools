TOOLCHAIN := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))

TARGETS = configure \
	python/configure

.PHONY: all

all: $(foreach T,$(TARGETS),$(TOOLCHAIN)/$(T))

$(TOOLCHAIN)/configure: $(TOOLCHAIN)/configure.ac
	cd $(@D) && autoreconf -fi .

$(TOOLCHAIN)/%/configure: $(TOOLCHAIN)/%/configure.ac
	cd $(@D) && autoreconf -fi .
