wrap_in_iframe <- function(html) {
  html <- paste(html, collapse = "\n")
  html <- gsub("'", "\"", html)

  html <- paste(
    "<iframe width = '100%' srcdoc = '", 
    html,
    "<style>table {margin-left: auto; margin-right: auto;}</style>",
    "<script src=\"https://cdn.jsdelivr.net/npm/@iframe-resizer/child@5.3.2\"></script>", 
    "'></iframe>", 
    sep = "\n"
  )

  paste(
    html,
    "<script>iframeResize({license: 'GPLv3', scrolling: 'yes', waitForLoad: true,}, 'iframe' );</script>",
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