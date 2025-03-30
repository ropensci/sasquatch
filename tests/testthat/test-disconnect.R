test_that("when connected disconnect sets ends sas", {
  skip_on_cran()
  skip_if_offline()
  skip_if_no_saspy_install()
  sas_connect_if_no_session("oda")

  expect_message(sas_disconnect(), "SAS connection terminated.", fixed = TRUE)
  expect_null(sas_get_session()$SASpid)
})

test_that("when disconnected already do nothing", {
  skip_on_cran()
  skip_if_offline()
  skip_if_no_saspy_install()
  try(suppressMessages(sas_disconnect()))

  expect_no_error(sas_disconnect())
})
