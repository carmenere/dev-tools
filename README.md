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
# ctx_app_bar__ENABLED = yes

PG_ADMIN = an.romanov
PG_CONFIG = /opt/homebrew/opt/postgresql@12/bin/pg_config

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
d__PG_ADMIN = an.romanov
d__PG_CONFIG = /opt/homebrew/opt/postgresql@12/bin/pg_config
```

## All on host
Create file `~/.dev-tools/host.mk`, for instance:
```bash
include ~/.dev-tools/vars.mk

# ctx_pg_ctl__ENABLED = yes

ctx_bar__ENABLED = yes
ctx_cargo_bar__ENABLED = yes
ctx_cargo_foo__ENABLED = yes
ctx_clickhouse__ENABLED = yes
ctx_clickhouse_cli__ENABLED = yes
ctx_foo__ENABLED = yes
ctx_pip_alembic_baz__ENABLED = yes
ctx_pip_pytest_bar__ENABLED = yes
ctx_pip_pytest_foo__ENABLED = yes
ctx_postgresql__ENABLED = yes
ctx_psql__ENABLED = yes
ctx_pytest_bar__ENABLED = yes
ctx_pytest_foo__ENABLED = yes
ctx_python__ENABLED = yes
ctx_redis__ENABLED = yes
ctx_redis_cli__ENABLED = yes
ctx_rustup__ENABLED = yes
ctx_sqlx_bar__ENABLED = yes
ctx_tmux__ENABLED = yes
ctx_venv_alembic_baz__ENABLED = yes
ctx_venv_pytest_bar__ENABLED = yes
ctx_venv_pytest_foo__ENABLED = yes
```

<br>

## All inside docker
Create file `~/.dev-tools/docker.mk`, for instance:
```bash
include %abs path to ~/.dev-tools/vars.mk%

# CTXES
ctx_docker_bar__ENABLED = yes
ctx_docker_clickhouse__ENABLED = yes
ctx_docker_foo__ENABLED = yes
ctx_docker_pg__ENABLED = yes
ctx_docker_redis__ENABLED = yes
ctx_docker_rust__ENABLED = yes
ctx_example__ENABLED = yes
ctx_example_bar__ENABLED = yes
ctx_example_clickhouse__ENABLED = yes
ctx_example_foo__ENABLED = yes
ctx_example_pg__ENABLED = yes
ctx_example_redis__ENABLED = yes
ctx_example_rust__ENABLED = yes
ctx_example_yaml__ENABLED = yes

# PUBLISH APPS
docker_bar__PUBLISH = 8080:80/tcp
docker_foo__PUBLISH = 9081:80/tcp

# PUBLISH SERVICES
docker_clickhouse__PUBLISH = $(d__CH_PORT):$(d__CH_PORT)/tcp
docker_pg__PUBLISH = $(d__PG_PORT):$(d__PG_PORT)/tcp
docker_redis__PUBLISH = $(d__REDIS_PORT):$(d__REDIS_PORT)/tcp

# Clients
redis_cli__CONFIG_REWRITE = no
```

<br>

## Mixed
Create file `~/.dev-tools/mixed.mk`, for instance:
```bash
include ~/.dev-tools/vars.mk

# CTXES: DOCKER
ctx_docker_clickhouse__ENABLED = yes
ctx_docker_pg__ENABLED = yes
ctx_docker_redis__ENABLED = yes
ctx_docker_rust__ENABLED = yes
ctx_example__ENABLED = yes
ctx_example_clickhouse__ENABLED = yes
ctx_example_foo__ENABLED = yes
ctx_example_redis__ENABLED = yes
ctx_example_rust__ENABLED = yes
ctx_example_yaml__ENABLED = yes

# CTXES: HOST
ctx_bar__ENABLED = yes
ctx_cargo_bar__ENABLED = yes
ctx_cargo_foo__ENABLED = yes
ctx_clickhouse_cli__ENABLED = yes
ctx_foo__ENABLED = yes
ctx_pip_alembic_baz__ENABLED = yes
ctx_pip_pytest_bar__ENABLED = yes
ctx_pip_pytest_foo__ENABLED = yes
ctx_psql__ENABLED = yes
ctx_pytest_bar__ENABLED = yes
ctx_pytest_foo__ENABLED = yes
ctx_python__ENABLED = yes
ctx_redis_cli__ENABLED = yes
ctx_rustup__ENABLED = yes
ctx_sqlx_bar__ENABLED = yes
ctx_tmux__ENABLED = yes
ctx_venv_alembic_baz__ENABLED = yes
ctx_venv_pytest_bar__ENABLED = yes
ctx_venv_pytest_foo__ENABLED = yes

# PUBLISH SERVICES
docker_clickhouse__PUBLISH = $(d__CH_PORT):$(d__CH_PORT)/tcp
docker_pg__PUBLISH = $(d__PG_PORT):$(d__PG_PORT)/tcp
docker_redis__PUBLISH = $(d__REDIS_PORT):$(d__REDIS_PORT)/tcp

# Clients
redis_cli__CONFIG_REWRITE = no
```