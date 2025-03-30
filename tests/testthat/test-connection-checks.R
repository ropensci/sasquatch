test_that("valid_session() returns true when connected", {
  skip_on_cran()
  skip_if_offline()
  skip_if_no_saspy_install()
  sas_connect_if_no_session("oda")

  expect_true(valid_session())
})

test_that("valid_session() returns false when disconnected", {
  skip_on_cran()
  skip_if_offline()
  skip_if_no_saspy_install()
  try(suppressMessages(sas_disconnect()))

  expect_false(valid_session())
})

test_that("check_session() does nothing when connected", {
  skip_on_cran()
  skip_if_offline()
  skip_if_no_saspy_install()
  sas_connect_if_no_session("oda")

  expect_no_error(check_session())
})

test_that("check_session() throws an error when disconnected", {
  try(suppressMessages(sas_disconnect()))

  expect_snapshot(check_session(), error = TRUE)
})

test_that("execute_if_connection_active() throws an error if connection disrupted", {
  skip_on_cran()
  skip_if_offline()
  skip_if_no_saspy_install()
  sas_connect_if_no_session("oda")

  expect_snapshot(
    execute_if_connection_active({
      .pkgenv$session$SASpid <- NULL
      stop()
    }),
    error = TRUE
  )
})

test_that("execute_if_connection_active() executes if connection not disrupted", {
  skip_on_cran()
  skip_if_offline()
  skip_if_no_saspy_install()
  sas_connect_if_no_session("oda")
  withr::defer(sas_get_session()$submit(
    "proc datasets library=WORK;delete cars;run;"
  ))
  expect_no_error(
    execute_if_connection_active({
      sas_get_session()$submit("DATA cars; SET sashelp.cars; RUN;")
    })
  )

  expect_true(sas_get_session()$exist("cars", "work"))
})
