# Dev-Tools
Various tools to support **build**, **deploy** and **test** automation.

<br>

# Local settings
1. Build toolchain:
```bash
make toolchain
```
2. To rewrite defaults create file `vars.mk` **out of source** tree of dev-tools:
```bash
mkdir ~/.dev-tools
touch ~/.dev-tools/vars.mk
```
3. Example of `~/.dev-tools/vars.mk`:
```bash
# ENABLE_bar = yes
PG_ADMIN = $(USER)
PG_CONFIG = /opt/homebrew/opt/postgresql@12/bin/pg_config
STOP_ALL = yes

# Docker
docker_bar__PUBLISH = 8080:80/tcp
docker_foo__PUBLISH = 8081:80/tcp
docker_pg__PUBLISH = 4$(PG_PORT):$(PG_PORT)/tcp
docker_redis__PUBLISH = 4$(REDIS_PORT):$(REDIS_PORT)/tcp

# Compose
stand_example__BAR_PUBLISH = 9080:80/tcp
stand_example__FOO_PUBLISH = 9081:80/tcp
stand_example__PG_PUBLISH = 5$(PG_PORT):$(PG_PORT)/tcp
stand_example__REDIS_PUBLISH = 5$(REDIS_PORT):$(REDIS_PORT)/tcp
```
4. Then run `configure.mk`:
```bash
make VARS=~/.dev-tools/vars.mk configure
```
5. Use predefined targets inside main `Makefile`:
```bash
make VARS=~/.dev-tools/vars.mk SEVERITY=debug init
```

```bash
make VARS=~/.dev-tools/vars.mk init
```

```bash
make VARS=~/.dev-tools/vars.mk start
```

```bash
make VARS=~/.dev-tools/vars.mk stop
```

```bash
make VARS=~/.dev-tools/vars.mk clean init start
```

```bash
make VARS=~/.dev-tools/vars.mk clean
```

```bash
make VARS=~/.dev-tools/vars.mk clean init tests
```
6. Also you can use separate makefiles in `.output`:
```bash
make -f .output/postgresql/Makefile add-auth-policy
make -f .output/psql/Makefile init
make -f .output/psql/Makefile connect
```

<br>

# Example
## ~/.dev-tools/vars.mk
Create file `~/.dev-tools/vars.mk`, for instance:
```bash
PG_ADMIN = $(USER)
PG_CONFIG = /opt/homebrew/opt/postgresql@12/bin/pg_config
STOP_ALL = yes
```

## All on host
Create file `~/.dev-tools/host.mk`, for instance:
```bash
include %abs path to ~/.dev-tools/vars.mk%

# CTXES
ENABLE_ALL_CTXES = yes
ENABLE_CTX_pg_ctl = no

# TAGS
ENABLE_ALL_TAGS = yes

ENABLE_TAG_image = no
ENABLE_TAG_docker_service = no
ENABLE_TAG_docker_app = no
ENABLE_TAG_docker_schema = no
```

<br>

## All inside docker
Create file `~/.dev-tools/docker.mk`, for instance:
```bash
include %abs path to ~/.dev-tools/vars.mk%

# CTXES
ENABLE_ALL_CTXES = yes

# TAGS
ENABLE_ALL_TAGS = no

ENABLE_TAG_image = yes
ENABLE_TAG_docker_service = yes
ENABLE_TAG_docker_app = yes
ENABLE_TAG_docker_schema = yes
ENABLE_TAG_cli = yes

# PUBLISH APPS
docker_bar__PUBLISH = 8080:80/tcp
docker_foo__PUBLISH = 9081:80/tcp

# PUBLISH SERVICES
docker_clickhouse__PUBLISH = $(CH_PORT):$(CH_PORT)/tcp
docker_pg__PUBLISH = $(PG_PORT):$(PG_PORT)/tcp
docker_redis__PUBLISH = $(REDIS_PORT):$(REDIS_PORT)/tcp

# Clients
redis_cli__CONFIG_REWRITE = no
```

<br>

## Mixed
Create file `~/.dev-tools/mixed.mk`, for instance:
```bash
include %abs path to ~/.dev-tools/vars.mk%

# CTXES
ENABLE_ALL_CTXES = yes
ENABLE_CTX_pg_ctl = no

# TAGS
ENABLE_ALL_TAGS = yes

ENABLE_TAG_host_service = no
ENABLE_TAG_image = no
ENABLE_TAG_docker_app = no
ENABLE_TAG_docker_schema = no

# PUBLISH SERVICES
docker_clickhouse__PUBLISH = $(CH_PORT):$(CH_PORT)/tcp
docker_pg__PUBLISH = $(PG_PORT):$(PG_PORT)/tcp
docker_redis__PUBLISH = $(REDIS_PORT):$(REDIS_PORT)/tcp

# Clients
redis_cli__CONFIG_REWRITE = no
```