# R Package Development: descriptiveStats

## Introduction

`descriptiveStats` is an R package providing a collection of simple functions for calculating common descriptive statistics from numeric vectors.

The package currently provides functions to calculate:

* Arithmetic mean
* Median
* Mode
* First quartile (Q1)
* Third quartile (Q3)
* Interquartile range (IQR)

The functions are designed to work with numeric vectors of any length and include handling for common edge cases such as missing values (`NA`), empty vectors, and single-value vectors.

All functions are documented using **Roxygen2** and exported for use by package users.

---

## Package Structure

The main package components are:

```text
descriptive_stats/
├── DESCRIPTION          # Package metadata
├── NAMESPACE            # Exported functions
├── R/                   # Function implementations
├── man/                 # Roxygen2-generated documentation
└── tests/
    └── testthat/        # Unit tests
```

---

## Functions

| Function        | Description                                     |
| --------------- | ----------------------------------------------- |
| `calc_mean()`   | Calculates the arithmetic mean                  |
| `calc_median()` | Calculates the median                           |
| `calc_mode()`   | Calculates the statistical mode                 |
| `calc_q1()`     | Calculates the first quartile (25th percentile) |
| `calc_q3()`     | Calculates the third quartile (75th percentile) |
| `calc_iqr()`    | Calculates the interquartile range              |


---

## Requirements

The package requires:

* R
* `roxygen2` for documentation
* `testthat` for unit testing
* `devtools` for package installation, testing, and validation

---

## Installation

The package can be installed locally from the package root using `devtools`:

```r
devtools::install()
```

After installation, load the package with:

```r
library(descriptiveStats)
```

---

## Handling Missing Values

`NA` values are ignored when calculating statistics. This is valid for every calculation method.

For example:

```r
x <- c(1, 2, 3, NA, 5)

```

The calculations are performed using the available non-missing values.


### Single value

A vector containing a single non-missing value is valid.

```r
calc_mean(10)
# 10

calc_median(10)
# 10

calc_mode(10)
# 10

calc_q1(10)
# 10

calc_q3(10)
# 10

calc_iqr(10)
# 0
```

### Empty vectors

Empty vectors cannot be used to calculate descriptive statistics.

For example:

```r
calc_mean(numeric(0))
```

produces an informative error rather than returning an invalid result.
The same behaviour applies to the other statistical functions.

### All values are `NA`

A vector containing only missing values cannot be used for the calculations:

```r
calc_mean(c(NA, NA, NA))
```

An informative error is returned.

### Invalid input

The functions expect numeric vectors. Passing non-numeric data results in an informative error.

For example:

```r
calc_mean(c("A", "B", "C"))
```

returns an error indicating that `x` must be a numeric vector.

---

## Mode Behaviour

`calc_mode()` identifies the value or values occurring most frequently.

### Single mode

```r
calc_mode(c(1, 1, 2, 3, 3, 3))
```

returns:

```text
3
```

### Multiple modes / ties

If multiple values have the same highest frequency, all modes are returned.

```r
calc_mode(c(1, 1, 2, 2, 3))
```

returns:

```text
1 2
```

### No mode

If every value occurs exactly once, there is no statistical mode.

```r
calc_mode(c(1, 2, 3, 4))
```

returns:

```text
numeric(0)
```

---

# Testing Guide

The package includes unit tests using the **testthat** framework.

The tests are located in:

```text
tests/
└── testthat/
    ├── test-calc_mean.R
    ├── test-calc_median.R
    ├── test-calc_mode.R
    ├── test-calc_q1.R
    ├── test-calc_q3.R
    └── test-calc_iqr.R
```

The tests cover both normal calculations and the edge cases specified for the package.

## Running the Tests

From the package root, run:

```r
devtools::test()
```
or run the folowng from /tests/ folder:

```r
library(testthat)
library(descriptiveStats)

test_check("descriptiveStats")
```

This executes all unit tests in the `tests/testthat/` directory.

---

## Documentation

Function documentation is generated using **Roxygen2**.

To regenerate the documentation after modifying the Roxygen comments:

```r
roxygen2::roxygenise()
```

This updates the generated documentation in the `man/` directory and the package `NAMESPACE`.

Individual function documentation can then be accessed in R using:

```r
?calc_mean
?calc_median
?calc_mode
?calc_q1
?calc_q3
?calc_iqr
```

---

## Summary

`descriptiveStats` provides a small, focused collection of descriptive-statistics functions with an emphasis on:

* Clear and reusable R functions
* Roxygen2 documentation
* Explicit handling of missing and invalid inputs
* Edge-case handling
* Unit testing with `testthat`
* Standard R package development practices

