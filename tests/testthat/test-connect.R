test_that("default connection", {
  skip_on_cran()
  skip_if_offline()
  withr::defer(suppressMessages(sas_disconnect()))

  expect_message(sas_connect(), "SAS Connection established.", fixed = TRUE)
  expect_s3_class(sas_get_session(), c("saspy.sasbase.SASsession", "python.builtin.object"))
})

test_that("specified cfgname", {
  skip_on_cran()
  skip_if_offline()

  "non-string cfgname"
  expect_error(sas_connect(1), "must be a string")

  # invalid cfgnames are handeled by `SASPy`

  "valid-string cfgname"
  expect_message(sas_connect(cfgname = "oda"), "SAS Connection established.", fixed = TRUE)
  expect_s3_class(sas_get_session(), c("saspy.sasbase.SASsession", "python.builtin.object"))
})
