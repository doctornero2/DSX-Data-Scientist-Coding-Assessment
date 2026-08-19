test_that("calc_q1 calculates the first quartile", {
  
  expect_equal(
    calc_q1(c(1, 2, 3, 4, 5)),
    2
  )
  
})


test_that("calc_q1 handles NA values", {
  
  expect_equal(
    calc_q1(c(1, 2, NA, 4, 5)),
    1.75
  )
  
})


test_that("calc_q1 handles a single value", {
  
  expect_equal(
    calc_q1(10),
    10
  )
  
})


test_that("calc_q1 rejects empty vectors", {
  
  expect_error(
    calc_q1(numeric(0)),
    "contains no non-missing values"
  )
  
})


test_that("calc_q1 rejects non-numeric input", {
  
  expect_error(
    calc_q1(c("a", "b")),
    "must be a numeric vector"
  )
  
})