test_that("non-existing cfgname throws error", {
  skip_on_cran()
  skip_if_offline()
  skip_if_no_saspy_install()
  suppressMessages(sas_disconnect())

  expect_snapshot(
    sas_connect(cfgname = "some config that doesn't exist"),
    transform = function(lines) {
      avail_config <- "Available configurations include: "
      gsub(paste0(avail_config, "(.*)"), avail_config, lines)
    },
    error = TRUE
  )
  expect_snapshot(
    sas_connect(cfgname = "anotherconfigthatdoesntexist"),
    transform = function(lines) {
      avail_config <- "Available configurations include: "
      gsub(paste0(avail_config, "(.*)"), avail_config, lines)
    },
    error = TRUE
  )
})

test_that("existing cfgname establishes connection", {
  skip_on_cran()
  skip_if_offline()
  skip_if_no_saspy_install()
  skip_if_no_configuration("oda")
  suppressMessages(sas_disconnect())

  expect_message(
    sas_connect(cfgname = "oda"),
    "SAS connection established.",
    fixed = TRUE
  )
  expect_s3_class(
    .pkgenv$session,
    c("saspy.sasbase.SASsession", "python.builtin.object")
  )
})

test_that("default connection establishes connection", {
  skip_on_cran()
  skip_if_offline()
  skip_if_no_saspy_install()
  skip_if_no_configuration("oda")
  suppressMessages(sas_disconnect())

  expect_message(sas_connect(), "SAS connection established.", fixed = TRUE)
  expect_s3_class(
    sas_get_session(),
    c("saspy.sasbase.SASsession", "python.builtin.object")
  )
})
