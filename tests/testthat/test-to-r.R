test_that("double should not be altered", {
  skip_on_cran()
  skip_if_offline()
  skip_if_no_saspy_install()
  sas_connect_if_no_session("oda")
  withr::defer(sas_get_session()$submit(
    "proc datasets library=WORK;delete x;run;"
  ))

  x <- data.frame(a = runif(1000, min = -1, max = 1))
  sas_from_r(x, "x")

  expect_equal(sas_to_r("x"), x)

  x$a[sample(1:nrow(x), 100)] <- NA
  sas_from_r(x, "x")

  expect_equal(sas_to_r("x"), x)
})

test_that("integer should become a double", {
  skip_on_cran()
  skip_if_offline()
  skip_if_no_saspy_install()
  sas_connect_if_no_session("oda")
  withr::defer(sas_get_session()$submit(
    "proc datasets library=WORK;delete x;run;"
  ))

  x <- data.frame(a = sample(-1000:1000, 1000, replace = TRUE))
  sas_from_r(x, "x")
  x_expected <- x
  x_expected$a <- as.double(x_expected$a)

  expect_equal(sas_to_r("x"), x)

  x$a[sample(1:nrow(x), 100)] <- NA
  sas_from_r(x, "x")
  x_expected <- x
  x_expected$a <- as.double(x_expected$a)

  expect_equal(sas_to_r("x"), x)
})

test_that("logical should become a double", {
  skip_on_cran()
  skip_if_offline()
  skip_if_no_saspy_install()
  sas_connect_if_no_session("oda")
  withr::defer(sas_get_session()$submit(
    "proc datasets library=WORK;delete x;run;"
  ))

  x <- data.frame(a = sample(c(TRUE, FALSE), 1000, replace = TRUE))
  sas_from_r(x, "x")
  x_expected <- x
  x_expected$a <- as.double(x_expected$a)

  expect_equal(sas_to_r("x"), x_expected)

  x$a[sample(1:nrow(x), 100)] <- NA
  sas_from_r(x, "x")
  x_expected <- x
  x_expected$a <- as.double(x_expected$a)

  expect_equal(sas_to_r("x"), x_expected)
})

test_that("character should not be altered", {
  skip_on_cran()
  skip_if_offline()
  skip_if_no_saspy_install()
  sas_connect_if_no_session("oda")
  withr::defer(sas_get_session()$submit(
    "proc datasets library=WORK;delete x;run;"
  ))

  x <- data.frame(
    a = sample(c("apple", "pear", "orange", "cherry"), 1000, replace = TRUE)
  )
  sas_from_r(x, "x")

  expect_equal(sas_to_r("x"), x)
  
  x$a[sample(1:nrow(x), 100)] <- NA
  sas_from_r(x, "x")
  
  expect_equal(sas_to_r("x"), x)
})

test_that("factor should become a character", {
  skip_on_cran()
  skip_if_offline()
  skip_if_no_saspy_install()
  sas_connect_if_no_session("oda")
  withr::defer(sas_get_session()$submit(
    "proc datasets library=WORK;delete x;run;"
  ))

  fruits <- c("apple", "pear", "orange", "cherry")
  x <- data.frame(
    a = factor(sample(fruits, 1000, replace = TRUE), levels = fruits)
  )
  sas_from_r(x, "x")
  x_expected <- x
  x_expected$a <- as.character(x_expected$a)

  expect_equal(sas_to_r("x"), x_expected)
  
  x$a[sample(1:nrow(x), 100)] <- NA
  sas_from_r(x, "x")
  x_expected <- x
  x_expected$a <- as.character(x_expected$a)
  
  expect_equal(sas_to_r("x"), x_expected)
})

test_that("POSIXct with local time should not be altered", {
  skip_on_cran()
  skip_if_offline()
  skip_if_no_saspy_install()
  sas_connect_if_no_session("oda")
  withr::defer(sas_get_session()$submit(
    "proc datasets library=WORK;delete x;run;"
  ))

  x <- data.frame(
    a = as.POSIXct(format(Sys.time() + sample(-1000:1000, 1000, replace = TRUE)))
  )
  sas_from_r(x, "x")

  expect_equal(sas_to_r("x"), x)
  
  x$a[sample(1:nrow(x), 100)] <- NA
  sas_from_r(x, "x")
  
  expect_equal(sas_to_r("x"), x)
})

test_that("POSIXct with non-local timezone should lose its timezone", {
  skip_on_cran()
  skip_if_offline()
  skip_if_no_saspy_install()
  sas_connect_if_no_session("oda")
  withr::defer(sas_get_session()$submit(
    "proc datasets library=WORK;delete x;run;"
  ))

  other_timezone <- sample(OlsonNames()[OlsonNames() != Sys.timezone()], 1)

  x <- data.frame(
    a = as.POSIXct(format(Sys.time() + sample(-1000:1000, 1000, replace = TRUE)), tz = other_timezone)
  )
  sas_from_r(x, "x")
  x_expected <- x
  x_expected$a <- as.POSIXct(format(x_expected$a))

  expect_equal(sas_to_r("x"), x_expected)
  
  x$a[sample(1:nrow(x), 100)] <- NA
  sas_from_r(x, "x")
  x_expected <- x
  x_expected$a <- as.POSIXct(format(x_expected$a))

  expect_equal(sas_to_r("x"), x_expected)
})

test_that("Dates should become a POSIXct", {
  skip_on_cran()
  skip_if_offline()
  skip_if_no_saspy_install()
  sas_connect_if_no_session("oda")
  withr::defer(sas_get_session()$submit(
    "proc datasets library=WORK;delete x;run;"
  ))

  x <- data.frame(
    a = Sys.Date() + sample(-1000:1000, 1000, replace = TRUE)
  )
  sas_from_r(x, "x")
  x_expected <- x
  x_expected$a <- as.POSIXct(format(x_expected$a))

  expect_equal(sas_to_r("x"), x_expected)
  
  x$a[sample(1:nrow(x), 100)] <- NA
  sas_from_r(x, "x")
  x_expected <- x
  x_expected$a <- as.POSIXct(format(x_expected$a))
  
  expect_equal(sas_to_r("x"), x_expected)
})

test_that("SAS to R data.frame", {
  skip_on_cran()
  skip_if_offline()
  skip_if_no_saspy_install()
  sas_connect_if_no_session("oda")
  withr::defer(sas_get_session()$submit(
    "proc datasets library=WORK;delete df_all;run;"
  ))

  df_all <- data.frame(
    dbl = c(1, 2.5, NA),
    int = c(1:2, NA),
    lgl = c(T, F, NA),
    chr = c("a", "b", NA),
    fct = factor(c("a", "b", NA)),
    dte = as.Date("2015-12-09") + c(1:2, NA),
    pos = as.POSIXct("2015-12-09 10:51:34.5678", tz = "UTC") + c(1:2, NA)
  )

  sas_from_r(df_all, "df_all")
  df_all_expected <- df_all
  df_all_expected$int <- as.double(df_all_expected$int)
  df_all_expected$lgl <- as.double(df_all_expected$lgl)
  df_all_expected$fct <- as.character(df_all_expected$fct)
  df_all_expected$dte <- as.POSIXct(format(df_all_expected$dte))
  df_all_expected$pos <- as.POSIXct(format(df_all_expected$pos))

  expect_equal(sas_to_r("df_all"), df_all_expected)
})
