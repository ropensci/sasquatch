test_that("SAS to R data.frame", {
  skip_if_offline()

  sas_connect()

  iris_sas <- sas_to_r("iris", "sashelp")
  
  # processing to get SAS and R data frames the same
  data(iris)
  names(iris_sas) <- c("Species", "Sepal.Length", "Sepal.Width",  "Petal.Length", "Petal.Width")
  iris_sas <- iris_sas[c(2:5, 1)]
  iris <- iris[order(iris$Species, iris$Sepal.Length, iris$Sepal.Width, iris$Petal.Length, iris$Petal.Width), ]
  iris_sas <- iris_sas[order(iris_sas$Species, iris_sas$Sepal.Length, iris_sas$Sepal.Width, iris_sas$Petal.Length, iris_sas$Petal.Width), ]
  iris_sas[1:4] <- iris_sas[1:4] / 10
  iris$Species <- as.character(iris$Species)
  iris_sas$Species <- tolower(iris_sas$Species)
  rownames(iris) <- NULL
  rownames(iris_sas) <- NULL

  expect_equal(iris, iris_sas)

  sas_disconnect()
})

test_that("R to SAS data.frame", {
  skip_if_offline()

  sas_connect()

  data(iris)
  r_to_sas(iris, "iris")
  iris_sas <- sas_to_r("iris")
  
  # processing to get SAS and R data frames the same
  attr(iris_sas, "pandas.index") <- NULL
  iris$Species <- as.character(iris$Species)

  expect_equal(iris, iris_sas)

  sas_disconnect()

})
