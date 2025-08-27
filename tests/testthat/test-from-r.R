# processing tests
test_that("double should not be altered", {
  x <- data.frame(a = runif(1000, min = -1, max = 1))

  expect_equal(x, from_r_data(x, factors_as_strings = FALSE))

  x$a[sample(seq_len(nrow(x)), 100)] <- NA

  expect_equal(from_r_data(x, factors_as_strings = FALSE), x)
})

test_that("integer should become a double", {
  x <- data.frame(a = sample(-1000:1000, 1000, replace = TRUE))
  x_expected <- x
  x_expected$a <- as.double(x_expected$a)

  expect_equal(from_r_data(x, factors_as_strings = FALSE), x_expected)

  x$a[sample(seq_len(nrow(x)), 100)] <- NA
  x_expected <- x
  x_expected$a <- as.double(x_expected$a)

  expect_equal(from_r_data(x, factors_as_strings = FALSE), x_expected)
})

test_that("logical should become a double", {
  x <- data.frame(a = sample(c(TRUE, FALSE), 1000, replace = TRUE))
  x_expected <- x
  x_expected$a <- as.double(x_expected$a)

  expect_equal(from_r_data(x, factors_as_strings = FALSE), x_expected)

  x$a[sample(seq_len(nrow(x)), 100)] <- NA
  x_expected <- x
  x_expected$a <- as.double(x_expected$a)

  expect_equal(from_r_data(x, factors_as_strings = FALSE), x_expected)
})

test_that("character should not be altered", {
  x <- data.frame(
    a = sample(c("apple", "pear", "orange", "cherry"), 1000, replace = TRUE)
  )

  expect_equal(from_r_data(x, factors_as_strings = FALSE), x)

  x$a[sample(seq_len(nrow(x)), 100)] <- NA

  expect_equal(from_r_data(x, factors_as_strings = FALSE), x)
})

test_that("factor as character", {
  x <- data.frame(
    a = as.factor(sample(
      c("apple", "pear", "orange", "cherry"),
      1000,
      replace = TRUE
    ))
  )
  x_expected <- x
  x_expected$a <- as.character(x_expected$a)

  expect_equal(from_r_data(x, factors_as_strings = TRUE), x_expected)

  x$a[sample(seq_len(nrow(x)), 100)] <- NA
  x_expected <- x
  x_expected$a <- as.character(x_expected$a)

  expect_equal(from_r_data(x, factors_as_strings = TRUE), x_expected)
})

test_that("factor as format (numeric)", {
  x <- data.frame(
    a = as.factor(sample(
      c("apple", "pear", "orange", "cherry"),
      1000,
      replace = TRUE
    ))
  )
  x_expected <- x
  x_expected$a <- as.numeric(x_expected$a)

  expect_equal(from_r_data(x, factors_as_strings = FALSE), x_expected)

  x$a[sample(seq_len(nrow(x)), 100)] <- NA
  x_expected <- x
  x_expected$a <- as.numeric(x_expected$a)

  expect_equal(from_r_data(x, factors_as_strings = FALSE), x_expected)
})

test_that("POSIXct should be converted to UTC", {
  x <- data.frame(
    a = as.POSIXct(format(
      Sys.time() + sample(-1000:1000, 1000, replace = TRUE)
    ))
  )
  x_expected <- x
  x_expected$a <- as.POSIXct(format(x_expected$a), tz = "UTC")

  expect_equal(from_r_data(x, factors_as_strings = FALSE), x_expected)

  x$a[sample(seq_len(nrow(x)), 100)] <- NA
  x_expected <- x
  x_expected$a <- as.POSIXct(format(x_expected$a), tz = "UTC")

  expect_equal(from_r_data(x, factors_as_strings = FALSE), x_expected)
})

test_that("date should become a POSIXct", {
  x <- data.frame(
    a = Sys.Date() + sample(-1000:1000, 1000, replace = TRUE)
  )
  x_expected <- x
  x_expected$a <- as.POSIXct(x_expected$a)

  expect_equal(from_r_data(x, factors_as_strings = FALSE), x_expected)

  x$a[sample(seq_len(nrow(x)), 100)] <- NA
  x_expected <- x
  x_expected$a <- as.POSIXct(x_expected$a)

  expect_equal(from_r_data(x, factors_as_strings = FALSE), x_expected)
})

test_that("date should be added to date dict", {
  x <- data.frame(
    a = Sys.Date() + sample(-1000:1000, 1000, replace = TRUE),
    b = as.POSIXct(Sys.Date() + sample(-1000:1000, 1000, replace = TRUE))
  )

  date_dict_expected <- list(
    a = "date"
  )

  expect_equal(
    reticulate::py_to_r(from_r_datedict(x)),
    date_dict_expected
  )
})

test_that("only the right types are allowed to be transfered", {
  local_mocked_bindings(check_session = function() {})

  expect_snapshot(
    sas_from_r(list2DF(
      list(
        int_col = 1:3,
        list_col = as.list(c(1:2, NA))
      )
    )),
    error = TRUE
  )

  expect_snapshot(
    sas_from_r(list2DF(
      list(
        int_col = 1:3,
        list_col = as.list(c(1:2, NA)),
        raw_col = as.raw(1:3),
        complex_col = c(1 + 2i, 3 + 4i, 5 + 6i)
      )
    )),
    error = TRUE
  )

  expect_snapshot(
    sas_from_r(list2DF(
      list(
        int_col = 1:3,
        list_col = as.list(c(1:2, NA)),
        raw_col = as.raw(1:3),
        complex_col = c(1 + 2i, 3 + 4i, 5 + 6i),
        matrix_col = I(matrix(1:3, nrow = 3))
      )
    )),
    error = TRUE
  )
})

test_that("colnames must start with a latin letter", {
  local_mocked_bindings(check_session = function() {})

  expect_snapshot(
    sas_from_r(list2DF(list(int = 1, `1` = 1)), "test"),
    error = TRUE
  )

  expect_snapshot(
    sas_from_r(list2DF(list(int = 1, `1` = 1, `(2)` = 2, `;3` = 3)), "test"),
    error = TRUE
  )

  expect_snapshot(
    sas_from_r(
      list2DF(list(int = 1, `1` = 1, `(2)` = 2, `;3` = 3, `&4` = 4)),
      "test"
    ),
    error = TRUE
  )
})

test_that("colnames must be less or equal than 32 bytes", {
  local_mocked_bindings(check_session = function() {})

  expect_snapshot(
    sas_from_r(
      list2DF(list(
        `AColumnNWhichIsShortEnoughForSAS` = 1,
        `AFirstReallyColumnNWhichIsTooLong` = 1
      )),
      "test"
    ),
    error = TRUE
  )

  expect_snapshot(
    sas_from_r(
      list2DF(list(
        `AColumnNWhichIsShortEnoughForSAS` = 1,
        `AFirstReallyColumnNWhichIsTooLong` = 1,
        `AReallyColumnNameWhichIsTooLongToSubmitToSAS` = 1,
        `AnotherReallyColumnNameWhichIsTooLong` = 1
      )),
      "test"
    ),
    error = TRUE
  )

  expect_snapshot(
    sas_from_r(
      list2DF(list(
        `AColumnNWhichIsShortEnoughForSAS` = 1,
        `AFirstReallyColumnNWhichIsTooLong` = 1,
        `AReallyColumnNameWhichIsTooLongToSubmitToSAS` = 1,
        `AnotherReallyColumnNameWhichIsTooLong` = 1,
        `LastReallyColumnNameWhichIsTooLong` = 1
      )),
      "test"
    ),
    error = TRUE
  )
})

test_that("colnames must be less or equal than 32 bytes", {
  local_mocked_bindings(check_session = function() {})

  expect_snapshot(
    sas_from_r(
      list2DF(list(
        `valid_col` = 1,
        `invalid col` = 1
      )),
      "test"
    ),
    error = TRUE
  )

  expect_snapshot(
    sas_from_r(
      list2DF(list(
        `valid_col` = 1,
        `invalid col` = 1,
        `invalid(col)` = 1,
        `invalid-col` = 1
      )),
      "test"
    ),
    error = TRUE
  )

  expect_snapshot(
    sas_from_r(
      list2DF(list(
        `valid_col` = 1,
        `invalid col` = 1,
        `invalid(col)` = 1,
        `invalid-col` = 1,
        `invalid+col` = 1
      )),
      "test"
    ),
    error = TRUE
  )
})
