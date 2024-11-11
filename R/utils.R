read_string <- function(filename) {
  readChar(filename, file.info(filename)$size)
}