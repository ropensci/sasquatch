test_that("list SAS files", {
  skip_on_cran()
  skip_if_offline()
  

  "path that doesn't exist"
  expect_length(sas_list("~/thisIsARandomPathThatDoesntExist"), 0)

  "path that does exist"
  root_files <- sas_list(".")
  expect_gt(length(root_files), 0)
  expect_true(is.character(root_files))
})
