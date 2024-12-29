test_that("htmlwidget output if kniting is not in progress", {
  skip_on_cran()
  skip_if_offline()
  withr::local_options(list(knitr.in.progress = FALSE))
  withr::defer(sas_get_session()$submit("proc datasets library=WORK;delete cars;run;"))

  options <- list()
  options$code <- "DATA work.cars; set sashelp.cars; where EngineSize > 2; RUN;"

  expect_s3_class(sas_engine(options), c("sas_widget", "htmlwidget"))
  expect_true(sas_get_session()$exist("cars", libref = "WORK"))
})

test_that("html; default", {
  skip_on_cran()
  skip_if_offline()
  withr::local_options(list(knitr.in.progress = TRUE))
  local_mocked_bindings(is_html_output = function() {TRUE})
  withr::defer(sas_get_session()$submit("proc datasets library=WORK;delete cars;run;"))

  options <- list()
  options$eval <- TRUE
  options$echo <- TRUE
  options$output <- TRUE
  options$include <- TRUE
  options$capture <- "both"
  options$code <- "DATA work.cars; set sashelp.cars; where EngineSize > 2; RUN;"

  output <- sas_engine(options)

  expect_match(substr(output, 1, nchar(options$code)), options$code, fixed = TRUE)
  expect_match(output, "## Output\n<iframe", fixed = TRUE)
  expect_match(output, "## Log\n<pre>", fixed = TRUE)
  expect_match(output, "::: panel-tabset", fixed = TRUE)
  expect_true(sas_get_session()$exist("cars", libref = "WORK"))
})

test_that("html; capture log", {
  skip_on_cran()
  skip_if_offline()
  withr::local_options(list(knitr.in.progress = TRUE))
  local_mocked_bindings(is_html_output = function() {TRUE})
  withr::defer(sas_get_session()$submit("proc datasets library=WORK;delete cars;run;"))

  options <- list()
  options$eval <- TRUE
  options$echo <- TRUE
  options$output <- TRUE
  options$include <- TRUE
  options$capture <- "log"
  options$code <- "DATA work.cars; set sashelp.cars; where EngineSize > 2; RUN;"

  output <- sas_engine(options)
  
  expect_match(substr(output, 1, nchar(options$code)), options$code, fixed = TRUE)
  expect_no_match(output, "<iframe", fixed = TRUE)
  expect_match(output, "<pre>", fixed = TRUE)
  expect_no_match(output, "::: panel-tabset", fixed = TRUE)
  expect_true(sas_get_session()$exist("cars", libref = "WORK"))
})

test_that("output; capture lst", {
  skip_on_cran()
  skip_if_offline()
  withr::local_options(list(knitr.in.progress = TRUE))
  local_mocked_bindings(is_html_output = function() {TRUE})
  withr::defer(sas_get_session()$submit("proc datasets library=WORK;delete cars;run;"))

  options <- list()
  options$eval <- TRUE
  options$echo <- TRUE
  options$output <- TRUE
  options$include <- TRUE
  options$capture <- "lst"
  options$code <- "DATA work.cars; set sashelp.cars; where EngineSize > 2; RUN;"

  output <- sas_engine(options)

  expect_match(substr(output, 1, nchar(options$code)), options$code, fixed = TRUE)
  expect_match(output, "<iframe", fixed = TRUE)
  expect_no_match(output, "<pre>", fixed = TRUE)
  expect_no_match(output, "::: panel-tabset", fixed = TRUE)
  expect_true(sas_get_session()$exist("cars", libref = "WORK"))
})

test_that("html; eval false", {
  skip_on_cran()
  skip_if_offline()
  withr::local_options(list(knitr.in.progress = TRUE))
  local_mocked_bindings(is_html_output = function() {TRUE})

  options <- list()
  options$eval <- FALSE
  options$echo <- TRUE
  options$output <- TRUE
  options$include <- TRUE
  options$capture <- "both"
  options$code <- "DATA work.cars; set sashelp.cars; where EngineSize > 2; RUN;"

  output <- sas_engine(options)

  expect_match(output, options$code, fixed = TRUE)
  expect_no_match(output, "<iframe", fixed = TRUE)
  expect_no_match(output, "<pre>", fixed = TRUE)
  expect_no_match(output, "::: panel-tabset", fixed = TRUE)
  expect_false(sas_get_session()$exist("cars", libref = "WORK"))
})

test_that("html; echo false", {
  skip_on_cran()
  skip_if_offline()
  withr::local_options(list(knitr.in.progress = TRUE))
  local_mocked_bindings(is_html_output = function() {TRUE})
  withr::defer(sas_get_session()$submit("proc datasets library=WORK;delete cars;run;"))

  options <- list()
  options$eval <- TRUE
  options$echo <- FALSE
  options$output <- TRUE
  options$include <- TRUE
  options$capture <- "both"
  options$code <- "DATA work.cars; set sashelp.cars; where EngineSize > 2; RUN;"

  output <- sas_engine(options)

  expect_no_match(substr(output, 1, nchar(options$code)), options$code, fixed = TRUE)
  expect_match(output, "<iframe", fixed = TRUE)
  expect_match(output, "<pre>", fixed = TRUE)
  expect_match(output, "::: panel-tabset", fixed = TRUE)
  expect_true(sas_get_session()$exist("cars", libref = "WORK"))
})

test_that("html; output false", {
  skip_on_cran()
  skip_if_offline()
  withr::local_options(list(knitr.in.progress = TRUE))
  local_mocked_bindings(is_html_output = function() {TRUE})
  withr::defer(sas_get_session()$submit("proc datasets library=WORK;delete cars;run;"))

  options <- list()
  options$eval <- TRUE
  options$echo <- TRUE
  options$output <- FALSE
  options$include <- TRUE
  options$capture <- "both"
  options$code <- "DATA work.cars; set sashelp.cars; where EngineSize > 2; RUN;"

  output <- sas_engine(options)

  expect_equal(output, options$code)
  expect_true(sas_get_session()$exist("cars", libref = "WORK"))
})

test_that("html; include false", {
  skip_on_cran()
  skip_if_offline()
  withr::local_options(list(knitr.in.progress = TRUE))
  local_mocked_bindings(is_html_output = function() {TRUE})
  withr::defer(sas_get_session()$submit("proc datasets library=WORK;delete cars;run;"))

  options <- list()
  options$eval <- TRUE
  options$echo <- TRUE
  options$output <- TRUE
  options$include <- FALSE
  options$capture <- "both"
  options$code <- "DATA work.cars; set sashelp.cars; where EngineSize > 2; RUN;"

  output <- sas_engine(options)

  expect_equal(output, "")
  expect_true(sas_get_session()$exist("cars", libref = "WORK"))
})

test_that("non-html; default", {
  skip_on_cran()
  skip_if_offline()
  withr::local_options(list(knitr.in.progress = TRUE))
  local_mocked_bindings(is_html_output = function() {FALSE})
  withr::defer(sas_get_session()$submit("proc datasets library=WORK;delete cars;run;"))

  options <- list()
  options$eval <- TRUE
  options$echo <- TRUE
  options$output <- TRUE
  options$include <- TRUE
  options$capture <- "both"
  options$code <- "DATA work.cars; set sashelp.cars; where EngineSize > 2; RUN;"

  expect_error(sas_engine(options), "No SAS temporary directory has been set. Use `sas_set_tempdir()", fixed = TRUE)

  sas_set_tempdir("~")
  output <- sas_engine(options)

  expect_match(substr(output, 1, nchar(options$code)), options$code, fixed = TRUE)
  expect_match(output, "## Output\n", fixed = TRUE)
  expect_match(output, "## Log\n```", fixed = TRUE)
  expect_match(output, "::: panel-tabset", fixed = TRUE)
  expect_true(sas_get_session()$exist("cars", libref = "WORK"))
})
