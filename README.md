# Dev-Tools
Various tools to support **build**, **deploy** and **test** automation.

<br>

## Local settings
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