test_that("checking if file exists on SAS", {
  skip_on_cran()
  skip_if_offline()
  sas_connect_if_no_session()
  local_path <- withr::local_tempfile(pattern = "temp", fileext = ".sas", lines = "PROC MEANS DATA = sashelp.cars; RUN;")
  withr::defer(sas_file_remove(sas_path))
  
  local_name <- basename(local_path)
  sas_path <- paste0("~/", local_name)

  "no file exists"
  expect_false(sas_file_exists(sas_path))

  "file exists"
  sas_file_upload(local_path, sas_path)
  expect_true(sas_file_exists(sas_path))
})
