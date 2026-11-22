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

test_that("echoed source is labelled as SAS for syntax highlighting", {
  withr::local_options(list(knitr.in.progress = TRUE))
  old_to <- knitr::opts_knit$get("rmarkdown.pandoc.to")
  knitr::opts_knit$set(rmarkdown.pandoc.to = "html")
  withr::defer(knitr::opts_knit$set(rmarkdown.pandoc.to = old_to))
  knitr::render_markdown()
  withr::defer(knitr::knit_hooks$restore())

  options <- knitr::opts_chunk$merge(list(
    code = c("data a;", "run;"),
    eval = FALSE,
    engine = "sas"
  ))
  out <- sas_engine(options)

  # "sas" first, so Pandoc 3.12+ highlights it; "txt" as the fallback
  expect_match(out, "{.sas .txt}", fixed = TRUE)
})
