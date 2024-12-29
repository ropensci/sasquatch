test_that("copying file from SAS", {
  skip_on_cran()
  skip_if_offline()
  withr::defer(file.remove(local_path))
  withr::defer(sas_file_remove(sas_path))
  withr::defer(sas_file_remove(sas_copy_path))
  
  local_path <- tempfile(pattern="temp", fileext=".sas")
  local_name <- basename(local_path)
  sas_path <- paste0("~/", local_name)
  sas_copy_path <- gsub(".sas", "_copy.sas", sas_path, fixed = TRUE)

  "no file exists copy"
  expect_warning(sas_file_copy(sas_path, sas_copy_path))

  "file exists copy"
  cat("PROC MEANS DATA = sashelp.cars; RUN;", file = local_path)
  sas_file_upload(local_path, sas_path)
  expect_true(sas_file_copy(sas_path, sas_copy_path))
  expect_true(sas_file_exists(sas_path))
  expect_true(sas_file_exists(sas_copy_path))
})