TOPDIR := $(shell pwd)

export SETTINGS = $(shell realpath $(VARS))
export SEVERITY ?= info

CONF = $(TOPDIR)/configure.mk
STAGES = $(TOPDIR)/stages.mk

.PHONY: all configure

all: configure

init:
	make -f $(CONF) init

configure: init
	make -f $(CONF) all

run: configure
	make -f $(STAGES) run

build:
	make -f $(STAGES) build

venv:
	make -f $(STAGES) venv

pip:
	make -f $(STAGES) pip

apps:
	make -f $(STAGES) apps

schemas:
	make -f $(STAGES) schemas

sysctl:
	make -f $(STAGES) sysctl

tests:
	make -f $(STAGES) tests

tmux:
	make -f $(STAGES) tmux

docker:
	make -f $(STAGES) docker