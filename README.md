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
STOP_DISABLED = yes

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
STOP_DISABLED = yes
```

## All on host
Create file `~/.dev-tools/host.mk`, for instance:
```bash
include %abs path to ~/.dev-tools/vars.mk%

ENABLE_HOST_APPS = yes
ENABLE_HOST_SERVICES = yes
ENABLE_INIT = yes
ENABLE_sqlx_foo = yes
ENABLE_sqlx_bar = yes
ENABLE_TESTS = yes
ENABLE_TMUX = yes
ENABLE_VENVS = yes

ENABLE_pg_ctl = no
```

<br>

## All inside docker
Create file `~/.dev-tools/docker.mk`, for instance:
```bash
include %abs path to ~/.dev-tools/vars.mk%

# CTXES
ENABLE_DOCKER_APPS = yes
ENABLE_DOCKER_SERVICES = yes
ENABLE_INIT = yes
ENABLE_docker_sqlx_foo = yes
ENABLE_docker_sqlx_bar = yes

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

# DOCKER
ENABLE_DOCKER_SERVICES = yes

# HOST
ENABLE_HOST_APPS = yes
ENABLE_INIT = yes
ENABLE_sqlx_foo = yes
ENABLE_sqlx_bar = yes
ENABLE_TESTS = yes
ENABLE_TMUX = yes
ENABLE_VENVS = yes

# PUBLISH SERVICES
docker_clickhouse__PUBLISH = $(CH_PORT):$(CH_PORT)/tcp
docker_pg__PUBLISH = $(PG_PORT):$(PG_PORT)/tcp
docker_redis__PUBLISH = $(REDIS_PORT):$(REDIS_PORT)/tcp

# Clients
redis_cli__CONFIG_REWRITE = no
```