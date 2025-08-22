test_that("htmlwidget output if kniting is not in progress", {
  skip_on_cran()
  skip_if_offline()
  skip_if_no_saspy_install()
  sas_connect_if_no_session("oda")
  withr::local_options(list(knitr.in.progress = FALSE))
  withr::defer(sas_get_session()$submit(
    "proc datasets library=WORK;delete cars;run;"
  ))

  options <- list(
    code = "DATA work.cars; set sashelp.cars; where EngineSize > 2; RUN;"
  )

  expect_s3_class(sas_engine(options), c("sas_widget", "htmlwidget"))
  expect_true(sas_get_session()$exist("cars", libref = "WORK"))
})
