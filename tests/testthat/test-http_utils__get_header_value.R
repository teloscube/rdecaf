sample_header <- list(
  "A" = "A",
  "B" = "B1",
  "B" = "B2",
  "C" = "",
  "x" = "x",
  "y" = "y1",
  "y" = "y2",
  "z" = ""
)

test_that("Empty header name causes an error.", {
  expect_error(get_header_value(sample_header, ""), 'name != "" is not TRUE')
})

test_that("Header keys are trimmed before the search.", {
  expect_error(get_header_value(sample_header, ""), 'name != "" is not TRUE')
  expect_error(get_header_value(sample_header, " "), 'name != "" is not TRUE')
  expect_equal(get_header_value(sample_header, " A "), get_header_value(sample_header, "A"))
})

test_that("Missing header name returns empty character vector.", {
  expect_equal(get_header_value(sample_header, "header-name-that-does-not-exist"), c())
})

test_that("Both single and multi-valued headers return correct values.", {
  expect_equal(get_header_value(sample_header, "A"), c("A"))
  expect_equal(get_header_value(sample_header, "B"), c("B1", "B2"))
  expect_equal(get_header_value(sample_header, "C"), c(""))
  expect_equal(get_header_value(sample_header, "x"), "x")
  expect_equal(get_header_value(sample_header, "y"), c("y1", "y2"))
  expect_equal(get_header_value(sample_header, "z"), "")
})

test_that("Case-insensitivity works.", {
  expect_equal(get_header_value(sample_header, "a"), get_header_value(sample_header, "A"))
  expect_equal(get_header_value(sample_header, "b"), get_header_value(sample_header, "B"))
  expect_equal(get_header_value(sample_header, "c"), get_header_value(sample_header, "C"))
  expect_equal(get_header_value(sample_header, "X"), get_header_value(sample_header, "x"))
  expect_equal(get_header_value(sample_header, "Y"), get_header_value(sample_header, "y"))
  expect_equal(get_header_value(sample_header, "Z"), get_header_value(sample_header, "z"))
})