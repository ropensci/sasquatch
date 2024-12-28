test_that("uploading and downloading to SAS", {
  skip_on_cran()
  skip_if_offline()
  skip_if(sas_get_session()$sascfg$name != "oda")
  
  local_path <- tempfile(pattern="temp", fileext=".sas")
  local_name <- basename(local_path)
  sas_path <- paste0("~/", local_name)

  "no file exists upload"
  expect_error(sas_file_upload(local_path, sas_path), "must specify an existing file")

  "file exists upload"
  cat("PROC MEANS DATA = sashelp.cars; RUN;", file = local_path)
  expect_true(sas_file_upload(local_path, sas_path))
  expect_true(sas_file_exists(sas_path))

  "file download"
  file.remove(local_path)
  expect_true(sas_file_download(sas_path, local_path))
  expect_true(file.exists(local_path))
})

test_that("removing file from SAS", {
  skip_on_cran()
  skip_if_offline()
  skip_if(sas_get_session()$sascfg$name != "oda")
  
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


test_that("copying file on SAS", {
  skip_on_cran()
  skip_if_offline()
  skip_if(sas_get_session()$sascfg$name != "oda")
  
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

  # clean up
  sas_file_remove(sas_path)
  sas_file_remove(sas_copy_path)
})