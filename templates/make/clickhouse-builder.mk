DEVTOOLS_DIR := {{ DEVTOOLS_DIR }}

include $(DEVTOOLS_DIR)/configure/defaults.mk
include $(DEVTOOLS_DIR)/templates/make/common/lib.mk

include {{ SETTINGS }}

# git clone https://github.com/ClickHouse/ClickHouse.git

VERSION = 23.2.5.46
TAG = clickhouse-server:$(VERSION)-alpine

build:
	cd /tmp
	git clone git@github.com:ClickHouse/ClickHouse.git
	cd ClickHouse
	git tag --list |  grep stable | sort -r | head
	git checkout v$(VERSION)-stable
	cd docker/server
	docker build --build-arg VERSION=$(VERSION) -f Dockerfile.alpine -t $(TAG) .
