#' @export
sas_copy_file <- function(local_path, sas_path) {
  .pkgenv[["session"]]$file_copy(path, sas_path)
}

#' @export
sas_rm_file <- function(path) {
  .pkgenv[["session"]]$file_copy(path, sas_path)
}

#' @export
sas_list_files <- function(path) {
  .pkgenv[["session"]]$dirlist(path)
}

#' @export
sas_read_csv <- function(file, table_name, libref = "WORK") {
  .pkgenv[["session"]]$read_csv(file, table_name, libref)
}

#' @export
sas_write_csv <- function(table_name, path, libref = "WORK") {
  .pkgenv[["session"]]$write_csv(path, table_name, libref)
}

#' @export
sas_write_parquet <- function(table_name, path, libref = "WORK") {
  .pkgenv[["session"]]$sasdata2parquet(path, table_name, libref)
}
