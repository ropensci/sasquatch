test_that("uploading file to SAS", {
  skip_on_cran()
  skip_if_offline()
  withr::defer(file.remove(local_path))
  withr::defer(sas_file_remove(sas_path))
  
  local_path <- tempfile(pattern="temp", fileext=".sas")
  local_name <- basename(local_path)
  sas_path <- paste0("~/", local_name)

  "no file exists upload"
  expect_error(sas_file_upload(local_path, sas_path), "must specify an existing file", fixed = TRUE)

  "file exists upload"
  cat("PROC MEANS DATA = sashelp.cars; RUN;", file = local_path)
  expect_true(sas_file_upload(local_path, sas_path))
  expect_true(sas_file_exists(sas_path))
})
