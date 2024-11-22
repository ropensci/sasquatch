wrap_in_iframe <- function(html) {
  html <- paste(html, collapse = "\n")
  html <- gsub("'", "\"", html)
  html <- gsub("background-color:\\s*?#fafbfe", "background-color: transparent", html)

  paste(
    "<iframe width = '100%' class='resizable-iframe' srcdoc = '", 
    html,
    "<style>table {margin-left: auto; margin-right: auto;}</style>",
    "'></iframe>",
    sep = "\n"
  )
}

wrap_in_pre <- function(html) {
  html <- paste(html, collapse = "\n")
  paste("<pre>", html, "</pre>")
}

wrap_in_panel_tabset <- function(lst, log) {
  paste(
    '::: panel-tabset',
    '## lst',
    lst,
    '## log',
    log,
    ':::
    ',
    sep="\n"
  )
}

check_connection <- function() {
  if (!exists("session", envir = .pkgenv) || is.null(.pkgenv$session)) {
    stop("No current SAS session. Use sas_connect() to start one.")
  }
}

read_file <- function(path) {
  if (!file.exists(path)) {
    stop("Input file does not exist.")
  }

  readChar(path, file.info(path)$size)
}

write_file <- function(output, path, overwrite) {
  if (file.exists(path) && !overwrite) {
    stop("Output file already exists. If you would like to overwrite the file, use overwrite = TRUE.")
  }

  cat(output, file = path)
}
