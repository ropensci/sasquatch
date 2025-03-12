test_that("chk_session", {
  skip_on_cran()
  skip_if_offline()
  sas_connect_if_no_session()

  "no error when connected"
  expect_true(vld_session())
  expect_no_error(chk_session())

  "error when disconnected"
  suppressMessages(sas_disconnect())

  expect_false(vld_session())
  expect_error(
    chk_session(),
    "No active SAS session. Use sas_connect() to start one.",
    fixed = TRUE
  )
})
