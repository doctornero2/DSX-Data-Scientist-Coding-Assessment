#' Calculate the interquartile range
#'
#' Calculates the interquartile range (IQR) of a numeric vector.
#' The IQR is defined as the third quartile (Q3) minus the first quartile (Q1).
#'
#' @param x A numeric vector.
#'
#' @return A single numeric value representing the interquartile range.
#'
#' @details
#' The interquartile range is calculated as:
#'
#' \deqn{IQR = Q3 - Q1}
#'
#' where Q1 is the 25th percentile and Q3 is the 75th percentile.
#'
#' `NA` values are ignored. If `x` is empty or contains only `NA` values,
#' the function returns an informative error.
#'
#' @examples
#' calc_iqr(c(1, 2, 3, 4, 5))
#' calc_iqr(c(10, 20, 30, 40, 50, 60))
#' calc_iqr(c(1, 2, NA, 4, 5))
#' calc_iqr(10)
#'
#' @export
calc_iqr <- function(x) {
  
  if (!is.numeric(x)) 
  {
    stop("Error format: the input must be a numeric vector.")
  }
  
  x <- x[!is.na(x)]
  
  if (length(x) == 0) 
  {
    stop("The input Vector is empty. It contains no non-missing values.")
  }
  
  calc_q3(x) - calc_q1(x)
}
