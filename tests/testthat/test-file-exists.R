test_that("checking if file exists on SAS", {
  skip_on_cran()
  skip_if_offline()
  withr::defer(file.remove(local_path))
  withr::defer(sas_file_remove(sas_path))
  
  local_path <- tempfile(pattern="temp", fileext=".sas")
  local_name <- basename(local_path)
  sas_path <- paste0("~/", local_name)

  "no file exists"
  expect_false(sas_file_exists(sas_path))

  "file exists"
  cat("PROC MEANS DATA = sashelp.cars; RUN;", file = local_path)
  sas_file_upload(local_path, sas_path)
  expect_true(sas_file_exists(sas_path))
})
