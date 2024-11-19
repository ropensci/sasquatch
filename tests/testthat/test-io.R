test_that("uploading files to SAS", {
  skip_if_offline()

  local_path <- paste0("test", test_number, ".sas")
  sas_path <- paste("/home", sas_username, local_path, sep = "/")

  "no connection + no file"
  expect_error(sas_upload(local_path, sas_path))

  "no connection + file"
  cat("PROC MEANS DATA = sashelp.cars;\nRUN;", file = local_path)
  expect_error(sas_upload(local_path, sas_path))

  sas_connect()

  "connection + file"
  expect_no_error(sas_upload(local_path, sas_path))

  "connection + no file"
  file.remove(local_path)
  expect_error(sas_upload(local_path, sas_path))

  sas_remove(sas_path)
  sas_disconnect()
})

test_that("download files from SAS", {
  skip_if_offline()

  local_path <- paste0("test", test_number, ".sas")
  sas_path <- paste("/home", sas_username, local_path, sep = "/")

  "no connection + no file"
  expect_error(sas_download(sas_path, local_path))

  "no connection + file"
  cat("PROC MEANS DATA = sashelp.cars;\nRUN;", file = local_path)
  sas_connect()
  sas_upload(local_path, sas_path)
  sas_disconnect()
  expect_error(sas_download(sas_path, local_path))

  sas_connect()

  "connection + file"
  expect_no_error(sas_download(sas_path, local_path))
  sas_remove(sas_path)

  "connection + no file"
  expect_error(sas_download(sas_path, local_path))

  sas_disconnect()
  file.remove(local_path)
})

test_that("removing files from SAS", {
  skip_if_offline()

  local_path <- paste0("test", test_number, ".sas")
  sas_path <- paste("/home", sas_username, local_path, sep = "/")

  "no connection + no file"
  expect_error(sas_remove(sas_path))

  "no connection + file"
  cat("PROC MEANS DATA = sashelp.cars;\nRUN;", file = local_path)
  sas_connect()
  sas_upload(local_path, sas_path)
  sas_disconnect()
  expect_error(sas_remove(sas_path))

  sas_connect()

  "connection + file"
  expect_no_error(sas_remove(sas_path))

  "connection + no file"
  expect_error(sas_remove(sas_path))

  sas_disconnect()
  file.remove(local_path)
})

test_that("listing files", {
  skip_if_offline()

  sas_path <- paste0("/home/", sas_username)

  "no connection"
  expect_error(sas_list(sas_path))

  "connection"
  sas_connect()
  expect_no_error(sas_list(sas_path))

  sas_disconnect()
})
