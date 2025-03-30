# only the right types are allowed to be transfered

    Code
      sas_from_r(list2DF(list(int_col = 1:3, list_col = as.list(c(1:2, NA)))))
    Condition
      Error in `sas_from_r()`:
      ! `x` must only contain logical, integer, numeric, factor, character, POSIXct, or Date columns.
      x list_col is a list column.

---

    Code
      sas_from_r(list2DF(list(int_col = 1:3, list_col = as.list(c(1:2, NA)), raw_col = as.raw(
        1:3), complex_col = c(1 + 0+2i, 3 + 0+4i, 5 + 0+6i))))
    Condition
      Error in `sas_from_r()`:
      ! `x` must only contain logical, integer, numeric, factor, character, POSIXct, or Date columns.
      x list_col is a list column.
      x raw_col is a raw vector column.
      x complex_col is a complex vector column.

---

    Code
      sas_from_r(list2DF(list(int_col = 1:3, list_col = as.list(c(1:2, NA)), raw_col = as.raw(
        1:3), complex_col = c(1 + 0+2i, 3 + 0+4i, 5 + 0+6i), matrix_col = I(matrix(1:
      3, nrow = 3)))))
    Condition
      Error in `sas_from_r()`:
      ! `x` must only contain logical, integer, numeric, factor, character, POSIXct, or Date columns.
      x list_col is a list column.
      x raw_col is a raw vector column.
      x complex_col is a complex vector column.
      ... and 1 more problem.

# colnames must start with a latin letter

    Code
      sas_from_r(list2DF(list(int = 1, `1` = 1)), "test")
    Condition
      Error in `sas_from_r()`:
      ! `x` column names must start with a latin letter.
      x 1 starts with "1".

---

    Code
      sas_from_r(list2DF(list(int = 1, `1` = 1, `(2)` = 2, `;3` = 3)), "test")
    Condition
      Error in `sas_from_r()`:
      ! `x` column names must start with a latin letter.
      x 1 starts with "1".
      x (2) starts with "(".
      x ;3 starts with ";".

---

    Code
      sas_from_r(list2DF(list(int = 1, `1` = 1, `(2)` = 2, `;3` = 3, `&4` = 4)),
      "test")
    Condition
      Error in `sas_from_r()`:
      ! `x` column names must start with a latin letter.
      x 1 starts with "1".
      x (2) starts with "(".
      x ;3 starts with ";".
      ... and 1 more problem.

# colnames must be less or equal than 32 bytes

    Code
      sas_from_r(list2DF(list(AColumnNWhichIsShortEnoughForSAS = 1,
        AFirstReallyColumnNWhichIsTooLong = 1)), "test")
    Condition
      Error in `sas_from_r()`:
      ! `x` column names must be less than or equal to 32 bytes.
      x AFirstReallyColumnNWhichIsTooLong is 33 bytes long.

---

    Code
      sas_from_r(list2DF(list(AColumnNWhichIsShortEnoughForSAS = 1,
        AFirstReallyColumnNWhichIsTooLong = 1,
        AReallyColumnNameWhichIsTooLongToSubmitToSAS = 1,
        AnotherReallyColumnNameWhichIsTooLong = 1)), "test")
    Condition
      Error in `sas_from_r()`:
      ! `x` column names must be less than or equal to 32 bytes.
      x AFirstReallyColumnNWhichIsTooLong is 33 bytes long.
      x AReallyColumnNameWhichIsTooLongToSubmitToSAS is 44 bytes long.
      x AnotherReallyColumnNameWhichIsTooLong is 37 bytes long.

---

    Code
      sas_from_r(list2DF(list(AColumnNWhichIsShortEnoughForSAS = 1,
        AFirstReallyColumnNWhichIsTooLong = 1,
        AReallyColumnNameWhichIsTooLongToSubmitToSAS = 1,
        AnotherReallyColumnNameWhichIsTooLong = 1,
        LastReallyColumnNameWhichIsTooLong = 1)), "test")
    Condition
      Error in `sas_from_r()`:
      ! `x` column names must be less than or equal to 32 bytes.
      x AFirstReallyColumnNWhichIsTooLong is 33 bytes long.
      x AReallyColumnNameWhichIsTooLongToSubmitToSAS is 44 bytes long.
      x AnotherReallyColumnNameWhichIsTooLong is 37 bytes long.
      ... and 1 more problem.

---

    Code
      sas_from_r(list2DF(list(valid_col = 1, `invalid col` = 1)), "test")
    Condition
      Error in `sas_from_r()`:
      ! `x` column names must only contain alphanumeric characters or underscores.
      x invalid col contains a special character " ".

---

    Code
      sas_from_r(list2DF(list(valid_col = 1, `invalid col` = 1, `invalid(col)` = 1,
        `invalid-col` = 1)), "test")
    Condition
      Error in `sas_from_r()`:
      ! `x` column names must only contain alphanumeric characters or underscores.
      x invalid col contains a special character " ".
      x invalid(col) contains a special character "(".
      x invalid-col contains a special character "-".

---

    Code
      sas_from_r(list2DF(list(valid_col = 1, `invalid col` = 1, `invalid(col)` = 1,
        `invalid-col` = 1, `invalid+col` = 1)), "test")
    Condition
      Error in `sas_from_r()`:
      ! `x` column names must only contain alphanumeric characters or underscores.
      x invalid col contains a special character " ".
      x invalid(col) contains a special character "(".
      x invalid-col contains a special character "-".
      ... and 1 more problem.

