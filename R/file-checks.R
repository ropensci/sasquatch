check_file <- function(
  x,
  x_name = "x",
  arg = rlang::caller_arg(x),
  call = rlang::caller_env()
) {
  check_string(x, arg = arg, call = call)

  if (dir.exists(x)) {
    cli::cli_abort(
      c(
        "{.arg {x_name}} must specify a file.",
        "x" = "`{.path {x}}` is a directory."
      ),
      call = call
    )
  } else if (!file.exists(x)) {
    cli::cli_abort(
      c(
        "{.arg {x_name}} must specify an existing file.",
        "x" = "`{.path {x}}` cannot be found."
      ),
      call = call
    )
  }
}

check_no_file <- function(
  x,
  call = rlang::caller_env()
) {
  if (file.exists(x)) {
    cli::cli_abort(
      c(
        "x" = "{.file {x}} already exists.",
        "i" = "If you would like to overwrite the file, specify {.code overwrite = TRUE}."
      ),
      call = call
    )
  }
}

check_file_ext <- function(x, ext, call = rlang::caller_env()) {
  # from tools::file_ext
  pos <- regexpr("\\.([[:alnum:]]+)$", x)
  file_ext <- ifelse(pos > -1L, substring(x, pos + 1L), "")
  #

  if (file_ext != ext) {
    cli::cli_abort(
      c(
        "{.arg output} must have the file extension {.arg {ext}}",
        "x" = "{.file {x}} has the file extension {.val {ext}}."
      ),
      call = call
    )
  }
}
