test_that("test connection", {
  skip_if_offline()

  expect_no_error(sas_connect())

  expect_no_error(sas_connect("oda"))

  expect_no_error(sas_get_session())

  expect_no_error(sas_disconnect())

  expect_error(sas_disconnect())

  expect_error(sas_get_session())
})
