SERVICE ?= {{ SERVICE }}
START_CMD ?= {{ START_CMD }}
STOP_CMD ?= {{ STOP_CMD }}

.PHONY: start stop restart

start:
	$(START_CMD)

stop:
	$(STOP_CMD)

restart: stop start
