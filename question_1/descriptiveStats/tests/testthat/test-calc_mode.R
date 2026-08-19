test_that("calc_mode identifies a single mode", {
  
  expect_equal(
    calc_mode(c(1, 1, 2, 3, 3, 3)),
    3
  )
  
})


test_that("calc_mode handles ties", {
  
  expect_equal(
    calc_mode(c(1, 1, 2, 2, 3)),
    c(1, 2)
  )
  
})


test_that("calc_mode identifies no mode", {
  
  expect_equal(
    calc_mode(c(1, 2, 3, 4)),
    numeric(0)
  )
  
})


test_that("calc_mode ignores NA values", {
  
  expect_equal(
    calc_mode(c(1, 1, 2, NA, 2, 3)),
    c(1, 2)
  )
  
})


test_that("calc_mode handles a single value", {
  
  expect_equal(
    calc_mode(10),
    numeric(0)
  )
  
})


test_that("calc_mode rejects empty vectors", {
  
  expect_error(
    calc_mode(numeric(0)),
    "contains no non-missing values"
  )
  
})


test_that("calc_mode rejects non-numeric input", {
  
  expect_error(
    calc_mode(c("a", "b")),
    "must be a numeric vector"
  )
  
})