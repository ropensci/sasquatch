test_that("default connection", {
  skip_on_cran()
  skip_if_offline()
  withr::defer(suppressMessages(sas_connect(cfgname = "oda")))

  "disconnect when connected"
  expect_message(sas_disconnect(), "SAS Connection terminated.", fixed = TRUE)
  expect_null(sas_get_session())

  "error when not connected"
  expect_error(sas_disconnect())
})
