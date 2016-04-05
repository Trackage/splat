<!-- README.md is generated from README.Rmd. Please edit that file -->
``` r
load("bulkdata/082_WI_MARCH2013fitSST.RData")
#load("bulkdata/19747_WI_DEC2011fitSST.RData")
library(raster)
#> Loading required package: sp
library(splat)
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:raster':
#> 
#>     intersect, select, union
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
sx <- splat(fit)
```
