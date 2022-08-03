AC_DEFUN([CHECK_VERSION],
[
    AC_MSG_CHECKING([for version $1 $2 $3 $4])
    AX_COMPARE_VERSION([$2], [$3], [$4],
                       [AC_MSG_RESULT([ok])],
                       [AC_MSG_RESULT([fail])
                        AC_MSG_ERROR([$1 version mismatch])])
])