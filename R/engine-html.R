sas_html_engine <- function(options) {
  code <- options$code

  evaluate <- knitr::knit_hooks$get('evaluate')
  res <- if (isFALSE(options$eval)) {
    as.source(code)
  } else {
    evaluate(
      sas_run_string_code(
        paste(code, collapse = "\n"),
        options$capture,
        options$out.width,
        options$out.height
      ),
      envir = knitr::knit_global(),
      new_device = FALSE,
      keep_warning = if (is.numeric(options$warning)) {
        TRUE
      } else {
        options$warning
      },
      keep_message = if (is.numeric(options$message)) {
        TRUE
      } else {
        options$message
      },
      stop_on_error = if (is.numeric(options$error)) {
        options$error
      } else {
        if (options$error && options$include) 0L else 2L
      },
      output_handler = knit_handlers_htmlwidget()
    )
  }
  res[[1]]$src <- code

  if (isFALSE(options$output)) {
    res[[2]] <- ""
  }

  output <- unlist(knitr::sew(res, options))
  output <- paste(c(output), collapse = '')

  if (!isFALSE(options$include)) {
    output
  } else if (is.null(s <- options$indent)) {
    ''
  } else {
    s
  }
}

knit_handlers_htmlwidget = function() {
  fun = function(x, ...) {
    res = withVisible(knitr::knit_print(x, ...))
    if (inherits(x, "htmlwidget")) {
      class(res$value) = c(class(res$value), "knit_asis_htmlwidget")
    }
    if (res$visible) res$value else invisible(res$value)
  }

  evaluate::new_output_handler(
    value = function(x, visible) {
      if (visible) fun(x)
    }
  )
}

sas_run_string_code <- function(input, capture, width, height) {
  args <- as.list(environment())
  args$capture <- args$capture %||% "both"

  rlang::expr(
    sasquatch::sas_run_string(!!!args)
  )
}

as.source = function(code) {
  list(structure(list(src = code), class = 'source'))
}
