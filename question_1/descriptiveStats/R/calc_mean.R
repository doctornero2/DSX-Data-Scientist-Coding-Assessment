#' Calculate the arithmetic mean
#'
#' Calculates the arithmetic mean of a numeric vector.
#' Entering Missing values (`NA`) are ignored.
#'
#' @param x A numeric vector.
#'
#' @return A numeric value representing the arithmetic mean.
#'
#' @details
#' `NA` values are removed before calculating the mean. If `x` is empty
#' or contains only `NA` values, the function returns an informative error.
#' A vector containing a single non-missing value returns that value.
#'
#' @examples
#' calc_mean(c(8, 2, 9, 4, 5))
#' calc_mean(c(50, 2, NA, 30))
#' calc_mean(78)
#'
#' @export
calc_mean <- function(x) {
  
  if (!is.numeric(x)) 
  {
    stop("Error format: the input must be a numeric vector.")
  }
  
  x <- x[!is.na(x)]
  
  if (length(x) == 0) 
  {
    stop("The input Vector is empty. It contains no non-missing values.")
  }
  
  sum(x) / length(x)
}

