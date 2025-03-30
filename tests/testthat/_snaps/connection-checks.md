# check_session() throws an error when disconnected

    Code
      check_session()
    Condition
      Error:
      x No active SAS connection.
      i Use `sasquatch::sas_connect()` to start a new SAS session.

# execute_if_connection_active() throws an error if connection disrupted

    Code
      execute_if_connection_active({
        .pkgenv$session$SASpid <- NULL
        stop()
      })
    Condition
      Error:
      x SAS connection has terminated unexpectedly.
      i Use `sasquatch::sas_connect()` to start new SAS session.

