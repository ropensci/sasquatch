test_that("oda configuration - sascfg_personal", {
  skip_on_cran()
  skip_if_no_saspy_install()
  tempdir <- withr::local_tempdir()
  tempfile <- paste0(tempdir, "/sascfg_personal.py")
  local_mocked_bindings(write_file = function(file, ...) {
    cat(file = tempfile, ...)
  })

  configs <- list(
    oda = list(
      java = "usr/bin/java",
      iomhost = list(
        'odaws01-usw2-2.oda.sas.com',
        'odaws02-usw2-2.oda.sas.com'
      ),
      iomport = 8591L,
      encoding = "utf-8",
      authkey = "oda"
    )
  )

  sascfg_personal_path <- write_sascfg_personal(
    configs,
    tempdir,
    overwrite = TRUE
  )

  expect_equal(
    readLines(tempfile),
    c(
      "SAS_config_names = ['oda']",
      "oda = {'java': 'usr/bin/java', 'iomhost': ['odaws01-usw2-2.oda.sas.com', 'odaws02-usw2-2.oda.sas.com'], 'iomport': 8591, 'encoding': 'utf-8', 'authkey': 'oda'}"
    )
  )
})

test_that("oda configuration - authinfo", {
  skip_on_cran()
  skip_if_no_saspy_install()
  tempfile <- withr::local_tempfile()
  local_mocked_bindings(write_file = function(file, ...) {
    cat(file = tempfile, ...)
  })

  suppressMessages(write_authinfo_template(
    overwrite = TRUE
  ))

  expect_equal(
    readLines(tempfile),
    "oda user {username} password {password}"
  )
})
