test_that("copying a file that doesn't exist throws an error", {
  skip_on_cran()
  skip_if_offline()
  skip_if_no_saspy_install()
  sas_connect_if_no_session("oda")

  sas_path <- tempfile("temp", "~", fileext = ".sas")
  sas_copy_path <- gsub(".sas", "_copy.sas", sas_path, fixed = TRUE)

  expect_warning(
    copy_success <- sas_file_copy(sas_path, sas_copy_path)
  )
  expect_false(copy_success)
})

test_that("copying a file that exist should result in a new file at the path specified", {
  skip_on_cran()
  skip_if_offline()
  skip_if_no_saspy_install()
  sas_connect_if_no_session("oda")
  local_path <- withr::local_tempfile(
    pattern = "temp",
    fileext = ".sas",
    lines = "PROC MEANS DATA = sashelp.cars; RUN;"
  )
  withr::defer(sas_file_remove(sas_path))
  withr::defer(sas_file_remove(sas_copy_path))

  local_name <- basename(local_path)
  sas_path <- paste0("~/", local_name)
  sas_copy_path <- gsub(".sas", "_copy.sas", sas_path, fixed = TRUE)

  sas_file_upload(local_path, sas_path)
  expect_true(sas_file_copy(sas_path, sas_copy_path))
  expect_true(sas_file_exists(sas_path))
  expect_true(sas_file_exists(sas_copy_path))
})
