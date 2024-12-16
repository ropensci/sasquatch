chk_connection <- function() {
  if (vld_connection()) {
    return(invisible())
  }
  chk::abort_chk("No active SAS session. Use sas_connect() to start one.")
}
vld_connection <- function() exists("session", envir = .pkgenv) && !is.null(.pkgenv$session)

chk_has_rownames <- function(x, x_name = NULL) {
  if (vld_has_rownames(x)) {
    return(invisible(x))
  }
  if (is.null(x_name)) x_name <- chk::deparse_backtick_chk(substitute(x))
  chk::wrn(x_name, " rownames will not be transferred as columns")
}
vld_has_rownames <- function(x) is.na(.row_names_info(x)[1])
