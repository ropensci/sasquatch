test_that("generate SAS widget from string", {
  skip_on_cran()
  skip_if_offline()
  sas_connect_if_no_session()
  
  expect_s3_class(sas_run_string("PROC MEANS DATA = sashelp.cars; RUN;"), c("sas_widget", "htmlwidget"))
})
