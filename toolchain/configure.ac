AC_INIT([toolchain], [0.1])
AC_CONFIG_MACRO_DIR([m4])

SET_ARG_VAR([IN], [$(pwd)/Makefile.in])
SET_ARG_VAR([OUT], [$(pwd)/Makefile])

AC_ARG_WITH([python],
[AS_HELP_STRING([--with-python], [Enable python])],
[with_python=yes],
[with_python=no])

AC_ARG_WITH([default_python],
[AS_HELP_STRING([--with-default-python], [Use default settings while configuring python])],
[with_default_python=yes],
[with_default_python=no])

SET_ARG_VAR([WITH_PYTHON_DEFAULTS], [$with_default_python])

AS_IF([test "$with_default_python" == yes],
[SET_ARG_VAR([WITH_PYTHON], [yes])],
[SET_ARG_VAR([WITH_PYTHON], [$with_python])])


AC_CONFIG_FILES([$OUT:$IN])
AC_OUTPUT