test_that("generate SAS widget from file", {
  skip_on_cran()
  skip_if_offline()
  withr::defer(file.remove(local_path))
  
  local_path <- tempfile(pattern="temp", fileext=".sas")

  "widget if no output path specified"
  cat("PROC MEANS DATA = sashelp.cars; RUN;", file = local_path)
  expect_s3_class(sas_run_file(local_path), c("sas_widget", "htmlwidget"))
})

test_that("generate output html and log from file", {
  skip_on_cran()
  skip_if_offline()
  withr::defer(file.remove(local_path))
  withr::defer(file.remove(local_html))
  withr::defer(file.remove(local_log))
  
  local_path <- tempfile(pattern="temp", fileext=".sas")
  local_html <- sub(".sas", ".html", local_path, fixed = TRUE)
  local_log <- sub(".sas", ".log", local_path, fixed = TRUE)

  "generate html if no output path specified"
  cat("PROC MEANS DATA = sashelp.cars; RUN;", file = local_path)
  sas_run_file(local_path, local_html)
  expect_true(file.exists(local_html))
})

test_that("overwrite output html and log from file", {
  skip_on_cran()
  skip_if_offline()
  withr::defer(file.remove(local_path))
  withr::defer(file.remove(local_html))
  withr::defer(file.remove(local_log))
  
  local_path <- tempfile(pattern="temp", fileext=".sas")
  local_html <- sub(".sas", ".html", local_path, fixed = TRUE)
  local_log <- sub(".sas", ".log", local_path, fixed = TRUE)

  "don't overwrite"
  cat("PROC MEANS DATA = sashelp.cars; RUN;", file = local_path)
  cat("test", file = local_html)
  expect_error(sas_run_file(local_path, local_html), "already exists. If you would like to overwrite the file, use overwrite = TRUE.", fixed = TRUE)

  "overwrite output"
  sas_run_file(local_path, local_html, overwrite = TRUE)
})