test_that("Connect and Disconnect to/from SAS session", {
  expect_error(sas_get_session())

  expect_equal(sas_connect(), invisible())

  expect_equal(sas_disconnect(), invisible())
})
