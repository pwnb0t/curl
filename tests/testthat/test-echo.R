context("echo with httpuv")

test_that("Echo a big file", {
  # Create a random file (~30 MB)
  # Note: can test even bigger files but curl_echo() is a bit slow on Windows
  for(i in 1:20){
    tmp <- tempfile()
    size <- runif(1, 3e5, 4e5)
    buf <- serialize(rnorm(size), NULL)
    writeBin(buf, tmp)
    on.exit(unlink(tmp))

    # Roundtrip via httpuv
    h <- curl::handle_setform(curl::new_handle(), myfile = curl::form_file(tmp))
    req <- curl::curl_echo(h)
    expect_equal(req$method, 'POST')

  }
})
