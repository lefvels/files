obfuscate <- function(x) {
  .tempfile1 <- tempfile(tmpdir = path.expand("~/"), fileext = ".txt")
  if (is.character(x)) {
    enc_lines <- readLines(x, warn = FALSE)
    writeLines(enc_lines, .tempfile1)
    dec_lines <- system(paste0("cat ", .tempfile1, " | base64 -d"), intern = TRUE)
    file.remove(.tempfile1)
    return(eval(parse(text = paste0(dec_lines, collapse = ""))))
  } else {
    prefix <- paste0(deparse(substitute(x)), "_", gsub("\\.", "_", class(x)[1]), "_")
    dput(x, file = .tempfile1)
    .tempfile2 <- tempfile(tmpdir = path.expand("~/"), fileext = ".txt")
    .tempfile2 <- sub("^(.*/)(.*)$", paste0("\\1", prefix, "\\2"), .tempfile2)
    system(paste0("cat ", .tempfile1, " | base64 > ", .tempfile2))
    file.remove(.tempfile1)
    system(paste("open -R", .tempfile2))
  }
}
