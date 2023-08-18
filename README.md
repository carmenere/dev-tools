# Dev-Tools
Various tools to support **build**, **deploy** and **test** automation.

<br>

## Local settings
1. To rewrite defaults create file `vars.mk` out of source tree of dev-tools:
```bash
mkdir ~/.dev-tools
touch ~/.dev-tools/vars.mk
```
2. Then run `configure.mk`:
```bash
make -f configure.mk VARS=~/.dev-tools/vars.mk all
```
3. Then you can use parameterized makefiles:
```bash
make -f /Users/an.romanov/Projects/ololo/dev-tools/.output/postgresql/Makefile add-auth-policy
make -f .output/psql/Makefile init
make -f .output/psql/Makefile connect
```
