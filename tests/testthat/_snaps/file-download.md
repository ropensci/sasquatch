# throw an error if the sas file does not exist

    Code
      download_success <- sas_file_download(sas_path, local_path)
    Condition
      Warning:
      `"non-existent file"` cannot be found.

# throw an error if the sas file is a directory

    Code
      download_success <- sas_file_download(sas_path, local_path)
    Condition
      Warning:
      `"~"` is a directory.

