TOOLCHAIN := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))

# WITH section
WITH_PYTHON = yes

# Paths
PYTHON_DIR = $(TOOLCHAIN)/python

.PHONY: init python

init: python

$(PYTHON_DIR)/Makefile:
ifeq ($(WITH_PYTHON),yes)
	cd $(PYTHON_DIR) && ./configure
endif

python: $(PYTHON_DIR)/Makefile
	cd $(PYTHON_DIR) && $(MAKE) -f $(PYTHON_DIR)/Makefile all

clean:
	rm -Rf $(TOOLCHAIN)/config.log
	rm -Rf $(TOOLCHAIN)/aclocal.m4
	rm -Rf $(TOOLCHAIN)/config.status
	rm -Rf $(TOOLCHAIN)/configure~
	rm -Rf $(TOOLCHAIN)/autom4te.cache
	if [[ -f $(PYTHON_DIR)/Makefile ]]; then cd $(PYTHON_DIR) && make clean; fi
	rm -Rf $(TOOLCHAIN)/Makefile

distclean:
	if [[ -f $(PYTHON_DIR)/Makefile ]]; then cd $(PYTHON_DIR) && make clean-dl; fi
	$(MAKE) clean
