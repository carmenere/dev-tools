TOOLCHAIN := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))

# WITH section
WITH_PYTHON_DEFAULTS = no
WITH_PYTHON = yes

# Paths
PYTHON = $(TOOLCHAIN)/python

.PHONY: init python

init: python

python:
ifeq ($(WITH_PYTHON_DEFAULTS),yes)
	cd $(PYTHON) && ./configure
endif
ifeq ($(WITH_PYTHON),yes)
	cd $(PYTHON) && \
	$(MAKE) -f Makefile init
endif

distclean:
	rm -Rf {$(TOOLCHAIN),$(TOOLCHAIN)/*}/config.log
	rm -Rf {$(TOOLCHAIN),$(TOOLCHAIN)/*}/aclocal.m4
	rm -Rf {$(TOOLCHAIN),$(TOOLCHAIN)/*}/config.status
	rm -Rf {$(TOOLCHAIN),$(TOOLCHAIN)/*}/configure~
	rm -Rf {$(TOOLCHAIN),$(TOOLCHAIN)/*}/autom4te.cache
