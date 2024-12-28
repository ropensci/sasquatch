test_that("test connection", {
  skip_on_cran()
  skip_if_offline()

  "connected connection"
  expect_no_error(chk_connection())

  "disconnection"
  expect_message(sas_disconnect(), "SAS Connection terminated.")
  expect_null(sas_get_session())

  "disconnected connection"
  expect_error(chk_connection(), "No active SAS session.")

  "connection"
  expect_message(sas_connect(), "SAS Connection established.")
  expect_s3_class(sas_get_session(), c("saspy.sasbase.SASsession", "python.builtin.object"))

  "specifying connection config"
  expect_message(sas_connect("oda"), "SAS Connection established.")
})
