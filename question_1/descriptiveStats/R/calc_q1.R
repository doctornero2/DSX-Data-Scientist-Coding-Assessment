#' Calculate the first quartile
#'
#' Calculates the first quartile (Q1), corresponding to the 25th percentile,
#' of a numeric vector.
#' Missing values (`NA`) are ignored.
#'
#' @param x A numeric vector.
#'
#' @return A single numeric value representing the first quartile (Q1).
#'
#' @details
#' The first quartile is calculated using R's default quantile method
#' (type 7). `NA` values are removed before calculation.
#'
#' If `x` is empty or contains only `NA` values, the function returns
#' an informative error.
#'
#' @examples
#' calc_q1(c(1, 2, 3, 4, 5))
#' calc_q1(c(10, 20, 30, 40, 50, 60))
#' calc_q1(c(1, 2, NA, 4, 5))
#' calc_q1(10)
#'
#' @export
calc_q1 <- function(x) {
  
  if (!is.numeric(x)) 
  {
    stop("Error format: the input must be a numeric vector.")
  }
  
  x <- x[!is.na(x)]
  
  if (length(x) == 0) 
  {
    stop("The input Vector is empty. It contains no non-missing values.")
  }
  
  as.numeric(stats::quantile(x, probs = 0.25, type = 7))
}
