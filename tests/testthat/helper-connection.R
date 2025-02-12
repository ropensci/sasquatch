skip_if_no_session <- function() {
  if (!vld_session()) {
    skip(message = "no session")
  }
}

sas_connect_if_no_session <- function() {
  if (!vld_session()) {
    suppressMessages(sas_connect())
  }
}