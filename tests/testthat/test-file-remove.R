test_that("removing file from SAS", {
  skip_on_cran()
  skip_if_offline()
  skip_if_no_saspy_install()
  sas_connect_if_no_session("oda")

  sas_path <- tempfile(pattern = "temp", tmpdir = "~", fileext = ".sas")

  "no file exists removal"
  expect_warning(
    remove_success <- sas_file_remove(sas_path)
  )
  expect_false(remove_success)
})

test_that("removing file from SAS", {
  skip_on_cran()
  skip_if_offline()
  skip_if_no_saspy_install()
  sas_connect_if_no_session("oda")
  local_path <- withr::local_tempfile(
    pattern = "temp",
    fileext = ".sas",
    lines = "PROC MEANS DATA = sashelp.cars; RUN;"
  )

  local_name <- basename(local_path)
  sas_path <- paste0("~/", local_name)

  sas_file_upload(local_path, sas_path)
  expect_true(sas_file_remove(sas_path))
  expect_false(sas_file_exists(sas_path))
})
