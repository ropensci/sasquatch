test_that("htmlwidget output if kniting is not in progress", {
  skip_on_cran()
  skip_if_offline()
  sas_connect_if_no_session()
  withr::local_options(list(knitr.in.progress = FALSE))
  withr::defer(sas_get_session()$submit("proc datasets library=WORK;delete cars;run;"))

  options <- list(
    code = "DATA work.cars; set sashelp.cars; where EngineSize > 2; RUN;"
  )

  expect_s3_class(sas_engine(options), c("sas_widget", "htmlwidget"))
  expect_true(sas_get_session()$exist("cars", libref = "WORK"))
})

test_that("html; default", {
  skip_on_cran()
  skip_if_offline()
  sas_connect_if_no_session()
  withr::local_options(list(knitr.in.progress = TRUE))
  local_mocked_bindings(is_html_output = function() {TRUE})
  withr::defer(sas_get_session()$submit("proc datasets library=WORK;delete cars;run;"))

  options <- list(
    echo = TRUE,
    eval = TRUE,
    output = TRUE,
    include = TRUE,
    capture = "both",
    code = "DATA work.cars; set sashelp.cars; where EngineSize > 2; RUN;"
  )

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
  sas_connect_if_no_session()
  withr::local_options(list(knitr.in.progress = TRUE))
  local_mocked_bindings(is_html_output = function() {TRUE})
  withr::defer(sas_get_session()$submit("proc datasets library=WORK;delete cars;run;"))

  options <- list(
    echo = TRUE,
    eval = TRUE,
    output = TRUE,
    include = TRUE,
    capture = "log",
    code = "DATA work.cars; set sashelp.cars; where EngineSize > 2; RUN;"
  )

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
  sas_connect_if_no_session()
  withr::local_options(list(knitr.in.progress = TRUE))
  local_mocked_bindings(is_html_output = function() {TRUE})
  withr::defer(sas_get_session()$submit("proc datasets library=WORK;delete cars;run;"))

  options <- list(
    echo = TRUE,
    eval = TRUE,
    output = TRUE,
    include = TRUE,
    capture = "lst",
    code = "DATA work.cars; set sashelp.cars; where EngineSize > 2; RUN;"
  )

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
  sas_connect_if_no_session()
  withr::local_options(list(knitr.in.progress = TRUE))
  local_mocked_bindings(is_html_output = function() {TRUE})

  options <- list(
    echo = TRUE,
    eval = FALSE,
    output = TRUE,
    include = TRUE,
    capture = "both",
    code = "DATA work.cars; set sashelp.cars; where EngineSize > 2; RUN;"
  )

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
  sas_connect_if_no_session()
  withr::local_options(list(knitr.in.progress = TRUE))
  local_mocked_bindings(is_html_output = function() {TRUE})
  withr::defer(sas_get_session()$submit("proc datasets library=WORK;delete cars;run;"))

  options <- list(
    echo = FALSE,
    eval = TRUE,
    output = TRUE,
    include = TRUE,
    capture = "both",
    code = "DATA work.cars; set sashelp.cars; where EngineSize > 2; RUN;"
  )

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
  sas_connect_if_no_session()
  withr::local_options(list(knitr.in.progress = TRUE))
  local_mocked_bindings(is_html_output = function() {TRUE})
  withr::defer(sas_get_session()$submit("proc datasets library=WORK;delete cars;run;"))

  options <- list(
    echo = TRUE,
    eval = TRUE,
    output = FALSE,
    include = TRUE,
    capture = "both",
    code = "DATA work.cars; set sashelp.cars; where EngineSize > 2; RUN;"
  )

  output <- sas_engine(options)

  expect_equal(output, options$code)
  expect_true(sas_get_session()$exist("cars", libref = "WORK"))
})

test_that("html; include false", {
  skip_on_cran()
  skip_if_offline()
  sas_connect_if_no_session()
  withr::local_options(list(knitr.in.progress = TRUE))
  local_mocked_bindings(is_html_output = function() {TRUE})
  withr::defer(sas_get_session()$submit("proc datasets library=WORK;delete cars;run;"))

  options <- list(
    echo = TRUE,
    eval = TRUE,
    output = TRUE,
    include = FALSE,
    capture = "both",
    code = "DATA work.cars; set sashelp.cars; where EngineSize > 2; RUN;"
  )

  output <- sas_engine(options)

  expect_equal(output, "")
  expect_true(sas_get_session()$exist("cars", libref = "WORK"))
})

test_that("non-html; default", {
  skip_on_cran()
  skip_if_offline()
  sas_connect_if_no_session()
  withr::local_options(list(knitr.in.progress = TRUE))
  local_mocked_bindings(is_html_output = function() {FALSE})

  options <- list(
    echo = TRUE,
    eval = TRUE,
    output = TRUE,
    include = TRUE,
    capture = "both",
    code = "DATA work.cars; set sashelp.cars; where EngineSize > 2; RUN;"
  )

  expect_error(sas_engine(options), "`sas_engine` cannot produce non-html output.", fixed = TRUE)
})
