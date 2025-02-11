test_that("oda configuration - sascfg_personal", {
  skip_on_cran()
  skip_if_offline()
  tempfile <- withr::local_tempfile()
  local_mocked_bindings(write_file = function(file, ...) {
    cat(file = tempfile, ...)
  })

  configs <- list(
    oda = list(
      java = "usr/bin/java",
      iomhost = list('odaws01-usw2-2.oda.sas.com', 'odaws02-usw2-2.oda.sas.com'),
      iomport = 8591L,
      encoding = "utf-8",
      authkey = "oda"
    )
  )

  sascfg_personal_path <- write_sascfg_personal(
    configs,
    overwrite = TRUE
  )

  expect_equal(
    readLines(tempfile),
    c(
      "SAS_config_names = ['oda']", 
      "oda = {'java': 'usr/bin/java', 'iomhost': ['odaws01-usw2-2.oda.sas.com', 'odaws02-usw2-2.oda.sas.com'], 'iomport': 8591, 'encoding': 'utf-8', 'authkey': 'oda'}"
    )
  )
  expect_match(sascfg_personal_path, "site-packages/saspy/sascfg_personal.py$")
})

test_that("oda configuration - authinfo", {
  skip_on_cran()
  skip_if_offline()
  tempfile <- withr::local_tempfile()
  local_mocked_bindings(write_file = function(file, ...) {
    cat(file = tempfile, ...)
  })

  authinfo_path <- write_authinfo(
    "oda",
    username = "my_username",
    password = "my_password",
    overwrite = TRUE
  )

  expect_equal(
    readLines(tempfile),
    'oda user my_username password my_password '
  )
})
