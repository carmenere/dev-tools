AC_DEFUN([CHECK_PROG],
[
    dnl Result of AC_CHECK_PROG is cached into variable ac_cv_prog_%VAR_NAME%, so clear it before.
    unset ac_cv_prog_RESULT
    AC_CHECK_PROG(RESULT, [$1 --version], [$1], [no])
    test "${RESULT}" == "no" && AC_MSG_ERROR([Required program $1 not found.])
    unset RESULT
])