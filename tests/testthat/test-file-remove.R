test_that("removing file from SAS", {
  skip_on_cran()
  skip_if_offline()
  local_path <- withr::local_tempfile(pattern = "temp", fileext = ".sas", lines = "PROC MEANS DATA = sashelp.cars; RUN;")
  
  local_name <- basename(local_path)
  sas_path <- paste0("~/", local_name)

  "no file exists removal"
  expect_warning(sas_file_remove(sas_path))

  "file exists removal"
  sas_file_upload(local_path, sas_path)
  expect_true(sas_file_remove(sas_path))
  expect_false(sas_file_exists(sas_path))
})
