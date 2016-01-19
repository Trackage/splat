<!-- README.md is generated from README.Rmd. Please edit that file -->
R Markdown
----------

``` r
load("bulkdata/082_WI_MARCH2013fitSST.RData")
#load("bulkdata/19747_WI_DEC2011fitSST.RData")
library(raster)
library(splat)
library(rbenchmark)
library(dplyr)
benchmark(
  Pimage = {px <- SGAT::Pimage(fit, type = "primary", proj = NULL)}, 
  splat = {sx <- tally(splat(fit) %>%  group_by(index, cell))}, 
  replications = 5)
#>     test replications elapsed relative user.self sys.self user.child
#> 1 Pimage            5   13.89    1.000     13.50     0.36         NA
#> 2  splat            5   38.58    2.778     37.89     0.66         NA
#>   sys.child
#> 1        NA
#> 2        NA

format(as.numeric(object.size(px) / object.size(sx)))
#> [1] "1.395879"


r0 <- px[] * 0
imgsp <- function(x) {
  suppressMessages(xx <- tally(x %>% group_by(cell)))
  r0[xx$cell] <- xx$n
  r0
} 
benchmark(PimageRaster = {pall <- px[]}, 
          splatRaster = {sall  <- imgsp(sx)}, 
          replications  = 10)
#>           test replications elapsed relative user.self sys.self user.child
#> 1 PimageRaster           10    0.48    1.000      0.48        0         NA
#> 2  splatRaster           10    0.70    1.458      0.70        0         NA
#>   sys.child
#> 1        NA
#> 2        NA
```
