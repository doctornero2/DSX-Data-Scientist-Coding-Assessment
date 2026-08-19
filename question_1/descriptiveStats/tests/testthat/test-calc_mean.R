test_that("calc_mean calculates the arithmetic mean", {
  
  expect_equal(
    calc_mean(c(1, 2, 3, 4, 5)),
    3
  )
  
})


test_that("calc_mean handles NA values", {
  
  expect_equal(
    calc_mean(c(1, 2, NA, 4)),
    7 / 3
  )
  
})


test_that("calc_mean handles a single value", {
  
  expect_equal(
    calc_mean(10),
    10
  )
  
})


test_that("calc_mean rejects empty vectors", {
  
  expect_error(
    calc_mean(numeric(0)),
    "contains no non-missing values"
  )
  
})


test_that("calc_mean rejects vectors containing only NA", {
  
  expect_error(
    calc_mean(c(NA, NA)),
    "Error format: the input must be a numeric vector."
  )
  
})


test_that("calc_mean rejects non-numeric input", {
  
  expect_error(
    calc_mean(c("a", "b", "c")),
    "must be a numeric vector"
  )
  
})