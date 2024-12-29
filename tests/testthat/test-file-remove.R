test_that("removing file from SAS", {
  skip_on_cran()
  skip_if_offline()
  withr::defer(file.remove(local_path))
  
  local_path <- tempfile(pattern="temp", fileext=".sas")
  local_name <- basename(local_path)
  sas_path <- paste0("~/", local_name)

  "no file exists removal"
  expect_warning(sas_file_remove(sas_path))

  "file exists removal"
  cat("PROC MEANS DATA = sashelp.cars; RUN;", file = local_path)
  sas_file_upload(local_path, sas_path)
  expect_true(sas_file_remove(sas_path))
  expect_false(sas_file_exists(sas_path))
})
