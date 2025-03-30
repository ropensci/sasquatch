test_that("return false if no file exists", {
  skip_on_cran()
  skip_if_offline()
  skip_if_no_saspy_install()
  sas_connect_if_no_session("oda")

  sas_path <- tempfile("temp", "~", ".sas")

  expect_false(sas_file_exists(sas_path))
})

test_that("checking if file exists on SAS", {
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

  local_name <- basename(local_path)
  sas_path <- paste0("~/", local_name)

  sas_file_upload(local_path, sas_path)
  expect_true(sas_file_exists(sas_path))
})
