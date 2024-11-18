test_that("Run SAS code from string", {
  sas_connect()

  expect_s3_class(sas_run_string("PROC MEANS DATA = sashelp.cars;\nRUN;"), "sas_widget")

  sas_disconnect()
})

test_that("Run SAS code from file", {
  local_path <- "test.sas"
  cat("PROC MEANS DATA = sashelp.cars;\nRUN;", file = local_path)

  sas_connect()
  expect_s3_class(sas_run_file(local_path), "sas_widget")

  sas_disconnect()
  file.remove(local_path)
})