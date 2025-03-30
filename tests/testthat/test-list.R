test_that("empty vector returned for path that doesn't exist", {
  skip_on_cran()
  skip_if_offline()
  skip_if_no_saspy_install()
  sas_connect_if_no_session("oda")

  file_list <- sas_list("~/thisIsARandomPathThatDoesntExist")

  expect_true(is.character(file_list))
  expect_length(file_list, 0)
})

test_that("list SAS files", {
  skip_on_cran()
  skip_if_offline()
  skip_if_no_saspy_install()
  sas_connect_if_no_session("oda")

  file_list <- sas_list(".")

  expect_true(is.character(file_list))
  expect_gt(length(file_list), 0)
})
