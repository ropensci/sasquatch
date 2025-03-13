skip_if_no_session <- function() {
  if (!valid_session()) {
    skip(message = "no session")
  }
}

sas_connect_if_no_session <- function() {
  if (!valid_session()) {
    suppressMessages(sas_connect())
  }
}
