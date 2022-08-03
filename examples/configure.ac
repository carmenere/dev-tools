AC_INIT([change-this-to-your-app-name], [0.0.0])
AC_CONFIG_MACRO_DIR([./dev-tools/m4])
AC_CONFIG_SRCDIR([Cargo.toml])

########################################################################################################################
# MAKE ARTEFACTS
########################################################################################################################
SET_ARG_VAR([ARTEFACTS], [top dir for artefacts], $(realpath ./.artefacts))

########################################################################################################################
# DEV TOOLS
########################################################################################################################
SET_ARG_VAR([DEV_TOOLS], [top dir for artefacts], $(realpath ./dev-tools))

########################################################################################################################
# BUILD
########################################################################################################################
SET_ARG_VAR([BUILD_BIN_NAME],    [executable file name], [change-this-to-your-app-name])
SET_ARG_VAR([BUILD_MODE],        [build mode],           [debug])
SET_ARG_VAR([BUILD_TARGET_ARCH], [build target arch],    [aarch64-apple-darwin])
SET_ARG_VAR([BUILD_VERSION],     [build version],        [$(git rev-parse --short=10 HEAD)])
SET_ARG_VAR([CPPFLAGS],          [CPPFLAGS env],         [$CPPFLAGS])
SET_ARG_VAR([LDFLAGS],           [LDFLAGS env],          [$LDFLAGS])

########################################################################################################################
# POSTGRESQL
########################################################################################################################
SET_ARG_VAR([POSTGRES_AUTH_METHOD],        [postgres auth method: { remote | peer | docker }], [remote])
SET_ARG_VAR([POSTGRES_HOST],               [postgres host],                                    [localhost])
SET_ARG_VAR([POSTGRES_MAJOR_VERSION],      [postgres major version],                           [12])
SET_ARG_VAR([POSTGRES_PORT],               [postgres port],                                    [5432])
SET_ARG_VAR([POSTGRES_SUPERUSER_DB],       [postgres superuser db],                            [postgres])
SET_ARG_VAR([POSTGRES_SUPERUSER_PASSWORD], [postgres superuser password],                      [postgres])
SET_ARG_VAR([POSTGRES_SUPERUSER],          [postgres superuser],                               [postgres])
SET_ARG_VAR([POSTGRES_USER_DB],            [postgres user db],                                 [change-this-to-your-dbname])
SET_ARG_VAR([POSTGRES_USER_PASSWORD],      [postgres user password],                           [12345])
SET_ARG_VAR([POSTGRES_USER],               [postgres user],                                    [change-this-to-your-service-user])
SET_ARG_VAR([POSTGRES_MIGRATIONS],         [postgres migrations dir],                          [$(realpath $srcdir)])

########################################################################################################################
# TESTS
########################################################################################################################
SET_ARG_VAR([PYTHONEXECUTABLE],     [Absolute path to python inerpreter],      [$(which python3)])
SET_ARG_VAR([VENV_NAME],            [VENV name],                               [tests])
SET_ARG_VAR([VENV_REQUIREMENTS],    [Relative path to dependencies],           [$srcdir/tests/requirements.txt])
SET_ARG_VAR([VENV_PACKAGE_MANAGER], [Package manager to install requirements], [pip])

########################################################################################################################
# cargo
########################################################################################################################
m4_define([PROG], [cargo])
CHECK_PROG([PROG])

########################################################################################################################
# rustc
########################################################################################################################
m4_define([PROG], [rustc])
m4_define([PROG_REQUIRED_VERSION], [1.58.1])
m4_define([PROG_ACTUAL_VERSION], [$(echo $(PROG --version) | grep -oE "[[0-9]]\.[[0-9]]+\.[[0-9]]+")])

CHECK_PROG([PROG])
CHECK_VERSION([PROG], [PROG_ACTUAL_VERSION], [eq], [PROG_REQUIRED_VERSION])

########################################################################################################################
# sqlx-cli
########################################################################################################################
m4_define([PROG], [sqlx])
m4_define([PROG_REQUIRED_VERSION], [0.5.10])
m4_define([PROG_ACTUAL_VERSION], [$(echo $(PROG --version) | grep -oE "[[0-9]]\.[[0-9]]+\.[[0-9]]+")])

AC_ARG_ENABLE([PROG],
              m4_expand([AS_HELP_STRING([--disable-[]PROG], [Skip ]PROG)]),
              [enable=false],
              [enable=true])

AM_CONDITIONAL([ENABLE], [test $enable = true])

AM_COND_IF([ENABLE],
           [CHECK_PROG([PROG])
            CHECK_VERSION([PROG], [PROG_ACTUAL_VERSION], [ge], [PROG_REQUIRED_VERSION])])

########################################################################################################################
# psql
########################################################################################################################
m4_define([PROG], [psql])
m4_define([PROG_REQUIRED_VERSION], [$POSTGRES_MAJOR_VERSION])
m4_define([PROG_ACTUAL_VERSION], [$(echo $(PROG -V) | grep -oE "[[0-9]]+\.[[0-9]]+")])

AC_ARG_ENABLE([PROG],
              m4_expand([AS_HELP_STRING([--disable-[]PROG], [Skip ]PROG)]),
              [enable=false],
              [enable=true])

AM_CONDITIONAL([ENABLE], [test $enable = true])

AM_COND_IF([ENABLE],
           [CHECK_PROG([PROG])
            CHECK_VERSION([PROG], [PROG_ACTUAL_VERSION], [ge], [PROG_REQUIRED_VERSION])])

########################################################################################################################
# LOG SEVERITIES
########################################################################################################################
SET_ARG_VAR([LOG_SEVERITY_DEFAULT],   [default log severity level],       [debug])
SET_ARG_VAR([LOG_SEVERITY_ACTIX_WEB], [log severity level for Actix web], [debug])
SET_ARG_VAR([LOG_SEVERITY_ACTIX],     [log severity level for Actix],     [debug])
SET_ARG_VAR([LOG_SEVERITY_SQLX],      [log severity level for sqlx],      [debug])

########################################################################################################################

AC_CONFIG_COMMANDS_PRE([
                        [echo creating $ARTEFACTS]
                        [mkdir -p $ARTEFACTS]
])

AC_CONFIG_FILES([$srcdir/Makefile:$srcdir/Makefile.in])
AC_CONFIG_FILES([$srcdir/Envs:$srcdir/Envs.in])

AC_CONFIG_FILES([src/config_h.rs])

AC_CONFIG_FILES([$ARTEFACTS/.env.postgresql:$DEV_TOOLS/mk/env/postgresql.in])
AC_CONFIG_FILES([$ARTEFACTS/.env.build:$DEV_TOOLS/mk/env/build.in])
AC_CONFIG_FILES([$ARTEFACTS/.env.venv:$DEV_TOOLS/mk/env/venv.in])
AC_CONFIG_FILES([$ARTEFACTS/.env.pytest:$DEV_TOOLS/mk/env/pytest.in])
AC_CONFIG_FILES([$ARTEFACTS/.env.sqlx:$DEV_TOOLS/mk/env/sqlx.in])


AC_OUTPUT