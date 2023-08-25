TOPDIR := $(shell pwd)

# If VARS is undefined $(shell realpath ) returns . (or current directory)
ifdef VARS
SETTINGS = $(shell realpath $(VARS))
else
SETTINGS =
endif

export SETTINGS
export SEVERITY ?= info

CONF = $(TOPDIR)/configure.mk
STAGES = $(TOPDIR)/stages.mk

.PHONY: all configure

all: configure

configure:
	make -f $(CONF) all

start: configure
	make -f $(STAGES) start

tests: configure
	make -f $(STAGES) tests

tmux-kill: configure
	make -f $(STAGES) tmux-kill