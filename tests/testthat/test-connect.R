test_that("default connection", {
  skip_on_cran()
  skip_if_offline()
  try(suppressMessages(sas_disconnect()), silent = TRUE)

  expect_message(sas_connect(), "SAS connection established.", fixed = TRUE)
  expect_s3_class(
    sas_get_session(),
    c("saspy.sasbase.SASsession", "python.builtin.object")
  )
})

test_that("specified cfgname", {
  skip_on_cran()
  skip_if_offline()
  try(supressMessages(sas_disconnect()), silent = TRUE)

  "non-string cfgname"
  expect_error(
    sas_connect(1),
    "`cfgname` must be a single string, not the number 1.",
    fixed = TRUE
  )

  # invalid cfgnames are handeled by `SASPy`

  "valid-string cfgname"
  expect_message(
    sas_connect(cfgname = "oda"),
    "SAS connection established.",
    fixed = TRUE
  )
  expect_s3_class(
    sas_get_session(),
    c("saspy.sasbase.SASsession", "python.builtin.object")
  )
})
