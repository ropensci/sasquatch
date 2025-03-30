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

test_that("knitting html with default options", {
  skip_on_cran()
  skip_if_offline()
  skip_if_no_saspy_install()
  sas_connect_if_no_session("oda")
  withr::local_options(list(knitr.in.progress = TRUE))
  local_mocked_bindings(is_html_output = function() {
    TRUE
  })
  withr::defer(sas_get_session()$submit(
    "proc datasets library=WORK;delete cars;run;"
  ))

  options <- list(
    echo = TRUE,
    eval = TRUE,
    output = TRUE,
    include = TRUE,
    capture = "both",
    code = "DATA work.cars; set sashelp.cars; where EngineSize > 2; RUN;"
  )
  output <- sas_engine(options)

  expect_snapshot(
    cat(output),
    transform = function(lines) {
      lines[!grepl("\024", lines)]
    }
  )
  expect_true(sas_get_session()$exist("cars", libref = "WORK"))
})

test_that("knitting html with no evaluation does not evaluate the code", {
  skip_on_cran()
  skip_if_offline()
  skip_if_no_saspy_install()
  sas_connect_if_no_session("oda")
  withr::local_options(list(knitr.in.progress = TRUE))
  local_mocked_bindings(is_html_output = function() {
    TRUE
  })

  options <- list(
    echo = TRUE,
    eval = FALSE,
    output = TRUE,
    include = TRUE,
    capture = "both",
    code = "DATA work.cars; set sashelp.cars; where EngineSize > 2; RUN;"
  )
  output <- sas_engine(options)

  expect_snapshot(
    cat(output),
    transform = function(lines) {
      lines[!grepl("\024", lines)]
    }
  )
  expect_false(sas_get_session()$exist("cars", libref = "WORK"))
})

test_that("knitting html with no echo shows no code", {
  withr::local_options(list(knitr.in.progress = TRUE))
  local_mocked_bindings(is_html_output = function() {
    TRUE
  })
  local_mocked_bindings(check_session = function() {
  })
  local_mocked_bindings(`.sas_run_string` = function(code) {
    list(LOG = "log output", LST = "lst output")
  })

  options <- list(
    echo = FALSE,
    eval = TRUE,
    output = TRUE,
    include = TRUE,
    capture = "both",
    code = "DATA work.cars; set sashelp.cars; where EngineSize > 2; RUN;"
  )
  output <- sas_engine(options)

  expect_no_match(output, options$code, fixed = TRUE)
  expect_snapshot(cat(output))
})

test_that("knitting html with no output shows no results", {
  withr::local_options(list(knitr.in.progress = TRUE))
  local_mocked_bindings(is_html_output = function() {
    TRUE
  })
  local_mocked_bindings(check_session = function() {
  })
  local_mocked_bindings(`.sas_run_string` = function(code) {
    list(LOG = "log output", LST = "lst output")
  })

  options <- list(
    echo = TRUE,
    eval = TRUE,
    output = FALSE,
    include = TRUE,
    capture = "both",
    code = "DATA work.cars; set sashelp.cars; where EngineSize > 2; RUN;"
  )
  output <- sas_engine(options)

  expect_no_match(output, "(log output)|(lst output)")
  expect_snapshot(cat(output))
})

test_that("knitting html with no include shows nothing", {
  withr::local_options(list(knitr.in.progress = TRUE))
  local_mocked_bindings(is_html_output = function() {
    TRUE
  })
  local_mocked_bindings(check_session = function() {
  })
  local_mocked_bindings(`.sas_run_string` = function(code) {
    list(LOG = "log output", LST = "lst output")
  })

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
})

test_that("knitting html with capture log doesnt show lst", {
  withr::local_options(list(knitr.in.progress = TRUE))
  local_mocked_bindings(is_html_output = function() {
    TRUE
  })
  local_mocked_bindings(check_session = function() {
  })
  local_mocked_bindings(`.sas_run_string` = function(code) {
    list(LOG = "log output", LST = "lst output")
  })

  options <- list(
    echo = TRUE,
    eval = TRUE,
    output = TRUE,
    include = TRUE,
    capture = "log",
    code = "DATA work.cars; set sashelp.cars; where EngineSize > 2; RUN;"
  )
  output <- sas_engine(options)

  expect_no_match(output, "(lst output)")
  expect_snapshot(cat(output))
})

test_that("knitting html with capture lst doesnt show log", {
  withr::local_options(list(knitr.in.progress = TRUE))
  local_mocked_bindings(is_html_output = function() {
    TRUE
  })
  local_mocked_bindings(check_session = function() {
  })
  local_mocked_bindings(`.sas_run_string` = function(code) {
    list(LOG = "log output", LST = "lst output")
  })

  options <- list(
    echo = TRUE,
    eval = TRUE,
    output = TRUE,
    include = TRUE,
    capture = "lst",
    code = "DATA work.cars; set sashelp.cars; where EngineSize > 2; RUN;"
  )
  output <- sas_engine(options)

  expect_no_match(output, "(log output)")
  expect_snapshot(cat(output))
})
