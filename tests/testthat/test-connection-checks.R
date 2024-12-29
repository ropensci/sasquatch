test_that("chk_connection", {
  skip_on_cran()
  skip_if_offline()
  withr::defer(suppressMessages(sas_connect(cfgname = "oda")))

  "no error when connected"
  expect_true(vld_connection())
  expect_no_error(chk_connection())

  "error when disconnected"
  suppressMessages(sas_disconnect())

  expect_false(vld_connection())
  expect_error(chk_connection(), "No active SAS session. Use sas_connect() to start one.", fixed = TRUE)
})
