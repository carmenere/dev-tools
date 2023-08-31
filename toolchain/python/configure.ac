AC_INIT([toolchain], [0.1])
AC_CONFIG_MACRO_DIR([../m4])

SET_ARG_VAR([IN], [$(pwd)/Makefile.in])
SET_ARG_VAR([OUT], [$(pwd)/Makefile])

SET_ARG_VAR([CC], [${CC}])
SET_ARG_VAR([CPPFLAGS], [${CPPFLAGS}])
SET_ARG_VAR([CXX], [${CXX}])
SET_ARG_VAR([DL], [.dl])
SET_ARG_VAR([INSTALL_SCHEMA], [""])
SET_ARG_VAR([LDFLAGS], [${LDFLAGS}])
SET_ARG_VAR([MAJOR], [3.11])
SET_ARG_VAR([MINOR], [4])
SET_ARG_VAR([OWNER], [${USER}])
SET_ARG_VAR([REQUIREMENTS], [$(pwd)/../../render/requirements.txt])
SET_ARG_VAR([SUDO], [$(which sudo)])
SET_ARG_VAR([USERBASE], [""])
SET_ARG_VAR([VENV_DIR], [".venv"])
SET_ARG_VAR([VENV_PROMT], ["[toolchain]"])

SET_ARG_VAR([PREFIX], ["$(echo ~/.py/${MAJOR}.${MINOR})"])
SET_ARG_VAR([PYTHON], ["${PREFIX}/bin/python${MAJOR}"])
SET_ARG_VAR([VPYTHON], ["${VENV_DIR}/bin/python"])

AC_CONFIG_FILES([$OUT:$IN])
AC_CONFIG_FILES([$(pwd)/defaults.mk:$(pwd)/defaults.in])
AC_OUTPUT