test_that("multiplication works", {
  sas_use_quarto()

  files <- c("sasquatch.qmd", "sas.xml")
  expect_true(all(files %in% list.files()))
  file.remove(files)
})
