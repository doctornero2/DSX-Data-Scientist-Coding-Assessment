test_that("calc_q3 calculates the third quartile", {
  
  expect_equal(
    calc_q3(c(1, 2, 3, 4, 5)),
    4
  )
  
})


test_that("calc_q3 handles NA values", {
  
  expect_equal(
    calc_q3(c(1, 2, NA, 4, 5)),
    4.25
  )
  
})


test_that("calc_q3 handles a single value", {
  
  expect_equal(
    calc_q3(10),
    10
  )
  
})


test_that("calc_q3 rejects empty vectors", {
  
  expect_error(
    calc_q3(numeric(0)),
    "contains no non-missing values"
  )
  
})


test_that("calc_q3 rejects non-numeric input", {
  
  expect_error(
    calc_q3(c("a", "b")),
    "must be a numeric vector"
  )
  
})