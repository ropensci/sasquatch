test_that("check_session", {
  skip_on_cran()
  skip_if_offline()
  sas_connect_if_no_session()

  "no error when connected"
  expect_true(valid_session())
  expect_no_error(check_session())

  "error when disconnected"
  suppressMessages(sas_disconnect())

  expect_false(valid_session())
  expect_error(
    check_session(),
    "No active SAS connection."
  )
})
