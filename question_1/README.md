# descriptiveStats

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

## Functions

| Function        | Description                                     |
| --------------- | ----------------------------------------------- |
| `calc_mean()`   | Calculates the arithmetic mean                  |
| `calc_median()` | Calculates the median                           |
| `calc_mode()`   | Calculates the statistical mode                 |
| `calc_q1()`     | Calculates the first quartile (25th percentile) |
| `calc_q3()`     | Calculates the third quartile (75th percentile) |
| `calc_iqr()`    | Calculates the interquartile range              |

The interquartile range is calculated as:

```text
IQR = Q3 - Q1
```

Quartiles use R's default quantile method (`type = 7`).

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

## Basic Usage

```r
library(descriptiveStats)

x <- c(1, 2, 2, 3, 4, 5, 5, 5)

calc_mean(x)
calc_median(x)
calc_mode(x)
calc_q1(x)
calc_q3(x)
calc_iqr(x)
```

The functions return numeric results that can be used directly in further R analyses.

---

## Handling Missing Values

`NA` values are ignored when calculating statistics.

For example:

```r
x <- c(1, 2, 3, NA, 5)

calc_mean(x)
calc_median(x)
calc_q1(x)
calc_q3(x)
calc_iqr(x)
```

The calculations are performed using the available non-missing values.

For `calc_mode()`, missing values are also ignored:

```r
calc_mode(c(1, 1, 2, NA, 2, 3))
```

---

## Edge Cases

The package explicitly handles several edge cases.

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

This executes all unit tests in the `tests/testthat/` directory.

A successful test run should report:

```text
FAIL 0
WARN 0
SKIP 0
```

## Test Coverage

The test suite verifies:

### `calc_mean()`

* Correct arithmetic mean
* Handling of `NA` values
* Single-value vectors
* Empty vectors
* Vectors containing only `NA`
* Invalid non-numeric input

### `calc_median()`

* Correct median for odd-length vectors
* Correct median for even-length vectors
* Handling of `NA` values
* Single-value vectors
* Empty vectors
* Invalid non-numeric input

### `calc_mode()`

* Single mode
* Multiple modes / ties
* No-mode cases
* Handling of `NA` values
* Single-value vectors
* Empty vectors
* Invalid non-numeric input

### `calc_q1()` and `calc_q3()`

* Correct quartile calculation
* Handling of `NA` values
* Single-value vectors
* Empty vectors
* Invalid non-numeric input

### `calc_iqr()`

* Correct calculation of `Q3 - Q1`
* Handling of `NA` values
* Single-value vectors
* Empty vectors
* Invalid non-numeric input

---

## Package Validation

In addition to the unit tests, the complete package can be checked using:

```r
devtools::check()
```

This performs additional checks on the package structure, documentation, namespace, examples, tests, and dependencies.

A clean package check should ideally complete with:

```text
0 errors
0 warnings
0 notes
```

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

## Package Structure

The main package components are:

```text
descriptive_stats/
├── DESCRIPTION          # Package metadata
├── NAMESPACE            # Exported functions
├── README.md            # Package documentation
├── R/                   # Function implementations
├── man/                 # Roxygen2-generated documentation
└── tests/
    └── testthat/        # Unit tests
```

## Requirements

The package requires:

* R
* `roxygen2` for documentation
* `testthat` for unit testing
* `devtools` for package installation, testing, and validation

---

## Summary

`descriptiveStats` provides a small, focused collection of descriptive-statistics functions with an emphasis on:

* Clear and reusable R functions
* Roxygen2 documentation
* Explicit handling of missing and invalid inputs
* Edge-case handling
* Unit testing with `testthat`
* Standard R package development practices

