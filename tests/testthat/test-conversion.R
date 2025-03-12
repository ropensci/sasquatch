test_that("back and forth", {
  skip_on_cran()
  skip_if_offline()
  sas_connect_if_no_session()

  df_all <- data.frame(
    a = c(1, 2.5, NA),
    b = c(1:2, NA),
    c = c(T, F, NA),
    d = c("a", "b", NA),
    e = factor(c("a", "b", NA)),
    f = as.Date("2015-12-09") + c(1:2, NA),
    g = as.POSIXct("2015-12-09 10:51:34.5678", tz = "UTC") + c(1:2, NA),
    h = I(as.list(c(1:2, NA))),
    i = I(list(list(1, 2:3), list(4:6), list(NA)))
  )

  "list columns: R to SAS"
  expect_error(
    sas_from_r(df_all, "df"),
    "must only have logical, integer, double, factor, character, POSIXct, or Date class columns.",
    fixed = TRUE
  )

  "valid columns: R to SAS"
  df <- df_all[!sapply(df_all, is.list)]
  expect_equal(sas_from_r(df, "df"), df)

  "rownames: R to SAS"
  rownames(df) <- paste("row", 1:3)
  expect_warning(
    sas_from_r(df, "df"),
    "rownames will not be transferred as a column",
    fixed = TRUE
  )
  rownames(df) <- NULL

  "back to R check"
  df_from_sas <- sas_to_r("df")
  df_from_sas$f <- as.Date(as.POSIXct(df_from_sas$f, tz = "UTC"))
  df_from_sas$g <- as.POSIXct(df_from_sas$g, tz = "UTC")
  df$c <- as.double(df$c)
  df$e <- as.character(df$e)
  expect_equal(df_from_sas, df)
})
