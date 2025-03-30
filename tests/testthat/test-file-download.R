test_that("throw an error if the sas file does not exist", {
  skip_on_cran()
  skip_if_offline()
  skip_if_no_saspy_install()
  sas_connect_if_no_session("oda")

  local_path <- tempfile(pattern = "temp", fileext = ".sas")
  local_name <- basename(local_path)
  sas_path <- paste0("~/", local_name)

  expect_snapshot(
    download_success <- sas_file_download(sas_path, local_path),
    transform = function(lines) {
      gsub(sas_path, "non-existent file", lines)
    }
  )
  expect_false(download_success)
})

test_that("throw an error if the sas file is a directory", {
  skip_on_cran()
  skip_if_offline()
  skip_if_no_saspy_install()
  sas_connect_if_no_session("oda")

  local_path <- tempfile(pattern = "temp", fileext = ".sas")
  sas_path <- "~"

  expect_snapshot(
    download_success <- sas_file_download(sas_path, local_path)
  )
  expect_false(download_success)
})

test_that("round-trip: upload to sas and download it from sas", {
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

  local_path_download <- tempfile(pattern = "temp", fileext = ".sas")
  local_name <- basename(local_path)
  sas_path <- paste0("~/", local_name)

  "file exists download"
  sas_file_upload(local_path, sas_path)
  expect_true(sas_file_download(sas_path, local_path_download))
  expect_true(file.exists(local_path_download))
  expect_equal(
    readLines(local_path_download, warn = FALSE),
    readLines(local_path, warn = FALSE)
  )
})
