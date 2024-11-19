test_that("Run SAS code from string", {
  skip_if_offline()

  expect_error(sas_run_string("PROC MEANS DATA = sashelp.cars;\nRUN;"))

  sas_connect()

  expect_s3_class(sas_run_string("PROC MEANS DATA = sashelp.cars;\nRUN;"), "sas_widget")

  sas_disconnect()
})

test_that("Run SAS code from file", {
  skip_if_offline()

  local_path <- "test.sas"
  output_path <- "test.html"
  cat("PROC MEANS DATA = sashelp.cars;\nRUN;", file = local_path)

  expect_error(sas_run_file(local_path))

  sas_connect()
  expect_s3_class(sas_run_file(local_path), "sas_widget")

  expect_no_error(sas_run_file(local_path, output_path))

  output_paths <- c(output_path, gsub("html", "log", output_path))
  expect_true(all(output_paths %in% list.files()))

  expect_error(sas_run_file(local_path, output_path))

  sas_disconnect()
  file.remove(c(local_path, output_paths))
})
