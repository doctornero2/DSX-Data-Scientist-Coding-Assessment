test_that("calc_median calculates the median", {
  
  expect_equal(
    calc_median(c(1, 2, 3, 4, 5)),
    3
  )
  
})


test_that("calc_median handles an even number of values", {
  
  expect_equal(
    calc_median(c(1, 2, 3, 4)),
    2.5
  )
  
})


test_that("calc_median handles NA values", {
  
  expect_equal(
    calc_median(c(1, 2, NA, 4)),
    2
  )
  
})


test_that("calc_median handles a single value", {
  
  expect_equal(
    calc_median(10),
    10
  )
  
})


test_that("calc_median rejects empty vectors", {
  
  expect_error(
    calc_median(numeric(0)),
    "contains no non-missing values"
  )
  
})


test_that("calc_median rejects non-numeric input", {
  
  expect_error(
    calc_median(c("a", "b")),
    "must be a numeric vector"
  )
  
})