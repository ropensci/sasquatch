sas_connect_if_no_session <- function(cfgname) {
  tryCatch(
    {
      suppressWarnings(suppressMessages(sas_connect(cfgname)))
    },
    error = function(e) {
      message <- paste0(
        "Cannot connect to `\"",
        cfgname,
        "\"` configuration."
      )
      skip(message)
    }
  )
}
