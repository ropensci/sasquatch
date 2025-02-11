test_that("generate SAS widget from file", {
  sas_connect()
  skip_on_cran()
  skip_if_offline()
  local_path <- withr::local_tempfile(pattern = "temp", fileext = ".sas", lines = "PROC MEANS DATA = sashelp.cars; RUN;")

  "widget if no output path specified"
  expect_s3_class(sas_run_file(local_path), c("sas_widget", "htmlwidget"))
})

test_that("generate output html and log from file", {
  skip_on_cran()
  skip_if_offline()
  local_dir_path <- withr::local_tempdir(pattern = "temp")
  
  local_path <- paste0(local_dir_path, "/", basename(tempfile(pattern = "temp", fileext = ".sas")))
  cat("PROC MEANS DATA = sashelp.cars; RUN;", file = local_path)
  local_html <- sub(".sas", ".html", local_path, fixed = TRUE)
  local_log <- sub(".sas", ".log", local_path, fixed = TRUE)

  "generate html if no output path specified"
  sas_run_file(local_path, local_html)
  expect_true(file.exists(local_html))
})

test_that("overwrite output html and log from file", {
  skip_on_cran()
  skip_if_offline()
  local_dir_path <- withr::local_tempdir(pattern = "temp")
  
  local_path <- paste0(local_dir_path, "/", basename(tempfile(pattern = "temp", fileext = ".sas")))
  cat("PROC MEANS DATA = sashelp.cars; RUN;", file = local_path)
  local_html <- sub(".sas", ".html", local_path, fixed = TRUE)
  cat("test", file = local_html)
  local_log <- sub(".sas", ".log", local_path, fixed = TRUE)

  "don't overwrite"
  expect_error(sas_run_file(local_path, local_html), "already exists. If you would like to overwrite the file, use overwrite = TRUE.", fixed = TRUE)

  "overwrite output"
  sas_run_file(local_path, local_html, overwrite = TRUE)
})