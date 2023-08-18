S_MIGRATOR ?= {{ S_MIGRATOR | default('', true) }}
F_MIGRATOR ?= {{ F_MIGRATOR | default('', true) }}
U_MIGRATOR ?= {{ U_MIGRATOR | default('', true) }}

schemas:
ifdef S_MIGRATOR
	$(MAKE) -f $(S_MIGRATOR) start
endif

fixtures:
ifdef F_MIGRATOR
	$(MAKE) -f $(F_MIGRATOR) start
endif

upgrade:
ifdef U_MIGRATOR
	$(MAKE) -f $(U_MIGRATOR) start
endif