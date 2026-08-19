#' Calculate the median
#'
#' Calculates the median of a numeric vector.
#' Entering Missing values (`NA`) are ignored.
#'
#' @param x A numeric vector.
#'
#' @return A single numeric value representing the median.
#'
#' @details
#' `NA` values are removed before calculating the median.
#' If `x` is empty or contains only `NA` values, the function returns
#' an informative error. A vector containing a single non-missing value
#' returns that value.
#'
#' @examples
#' calc_median(c(1, 2, 3, 4, 5))
#' calc_median(c(1, 2, 3, 4))
#' calc_median(c(10, NA, 20, 30))
#' calc_median(54)
#'
#' @export
calc_median <- function(x) {
  
  if (!is.numeric(x)) 
  {
    stop("Error format: the input must be a numeric vector.")
  }
  
  x <- x[!is.na(x)]
  
  if (length(x) == 0) 
  {
    stop("The input Vector is empty. It contains no non-missing values.")
  }
  
  # stats library - median(x) function
  stats::median(x)
  
  # alternative solution: median algorithm
  # --------------------------------------
  #x <- sort(x)
  #n <- length(x)
  #
  #if (n %% 2 == 1) {
  #  # Odd number of observations
  #  return(x[(n + 1) / 2])
  #} else {
  #  # Even number of observations
  #  return((x[n / 2] + x[n / 2 + 1]) / 2)
  #}
  
}
