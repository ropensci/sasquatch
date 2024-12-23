chk_has_rownames <- function(x, x_name = NULL) {
  if (vld_has_rownames(x)) {
    return(invisible(x))
  }
  if (is.null(x_name)) x_name <- chk::deparse_backtick_chk(substitute(x))
  chk::wrn(x_name, " rownames will not be transferred as a column")
}
vld_has_rownames <- function(x) is.na(.row_names_info(x, type = 0)[1])
