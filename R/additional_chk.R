chk_has_rownames <- function(x, x_name = NULL) {
  if (vld_has_rownames(x)) {
    return(invisible(x))
  }
  if (is.null(x_name)) x_name <- chk::deparse_backtick_chk(substitute(x))
  chk::wrn(x_name, " rownames will not be transferred as a column")
}
vld_has_rownames <- function(x) is.na(.row_names_info(x, type = 0)[1])

chk_has_sas_vld_datatypes <- function(x, x_name = NULL) {
  if (vld_has_sas_vld_datatypes(x)) {
    return(invisible(x))
  }
  if (is.null(x_name)) x_name <- chk::deparse_backtick_chk(substitute(x))
  chk::abort_chk(x_name, " must only have logical, integer, double, factor, character, POSIXct, or Date class columns")
}
vld_has_sas_vld_datatypes <- function(x) {
  all(sapply(x, \(col) inherits(col, c("logical", "integer", "numeric", "factor", "character", "POSIXct", "Date"))))
}