sas_widget <- function(sas_html, width = NULL, height = NULL, elementId = NULL) {

  # forward options using x
  x = list(
    sas_html = sas_html
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'sas_widget',
    x,
    width = width,
    height = height,
    package = 'sasr',
    elementId = elementId
  )
}