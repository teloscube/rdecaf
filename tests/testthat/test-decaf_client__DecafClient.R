httpbin_base_url <- "https://httpbin.org"
httpbin_echo_endpoint <- "/anything"
httpbin_dummy_credentials <- list(token = "HEBELEHUBELE")

test_that("Core request headers are passed correctly", {
  ## Prepare the client:
  client <- DecafClient$new(url = httpbin_base_url, credentials = httpbin_dummy_credentials)

  ## Place a GET request to the echo endpoint:
  response <- jsonlite::fromJSON(client$bare$get(httpbin_echo_endpoint)$parse("UTF-8"))

  ## Check headers:
  expect_equal(get_header_value(response$headers, "Authorization"), sprintf("Token %s", httpbin_dummy_credentials))
  expect_match(get_header_value(response$headers, "User-Agent"), "rdecaf", fixed = TRUE)
  expect_match(get_header_value(response$headers, "User-Agent"), as.character(packageVersion("rdecaf"), fixed = TRUE))
  expect_match(get_header_value(response$headers, "User-Agent"), Sys.info()["sysname"], fixed = TRUE)
  expect_match(get_header_value(response$headers, "User-Agent"), Sys.info()["nodename"], fixed = TRUE)
  expect_equal(get_header_value(response$headers, "X-DECAF-URL"), httpbin_base_url)
  expect_equal(get_header_value(response$headers, "X-DECAF-APIURL"), sprintf("%s/api", httpbin_base_url))
  expect_equal(get_header_value(response$headers, "X-DECAF-API-URL"), sprintf("%s/api", httpbin_base_url))
})
