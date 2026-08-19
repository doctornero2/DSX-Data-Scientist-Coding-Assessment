test_that("calc_iqr calculates the interquartile range", {
  
  expect_equal(
    calc_iqr(c(1, 2, 3, 4, 5)),
    2
  )
  
})


test_that("calc_iqr calculates Q3 minus Q1", {
  
  x <- c(1, 2, 3, 4, 5, 6, 7, 8, 9)
  
  expect_equal(
    calc_iqr(x),
    calc_q3(x) - calc_q1(x)
  )
  
})


test_that("calc_iqr handles NA values", {
  
  expect_equal(
    calc_iqr(c(1, 2, NA, 4, 5)),
    2.5
  )
  
})


test_that("calc_iqr handles a single value", {
  
  expect_equal(
    calc_iqr(10),
    0
  )
  
})


test_that("calc_iqr rejects empty vectors", {
  
  expect_error(
    calc_iqr(numeric(0)),
    "contains no non-missing values"
  )
  
})


test_that("calc_iqr rejects non-numeric input", {
  
  expect_error(
    calc_iqr(c("a", "b")),
    "must be a numeric vector"
  )
  
})