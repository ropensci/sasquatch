test_that("generate SAS widget from string", {
  skip_on_cran()
  skip_if_offline()
  
  expect_s3_class(sas_run_string("PROC MEANS DATA = sashelp.cars; RUN;"), c("sas_widget", "htmlwidget"))
})
