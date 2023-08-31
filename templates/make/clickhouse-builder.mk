
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
