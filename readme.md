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
  splat = {sx <- splat(fit)}, 
  replications = 1)
#>     test replications elapsed relative user.self sys.self user.child
#> 1 Pimage            1    2.69    1.000      2.56     0.11         NA
#> 2  splat            1    2.93    1.089      2.74     0.19         NA
#>   sys.child
#> 1        NA
#> 2        NA


format(as.numeric(object.size(px) / object.size(sx)))
#> [1] "1.861207"


r0 <- px[] * 0
imgsp <- function(x) {
  suppressMessages(xx <- tally(x %>% group_by(cell)))
  r0[xx$cell] <- xx$n
  r0
} 
imgsp2 <- function(x) {
  suppressMessages(xx <- x %>% group_by(cell) %>% summarize(n = sum(bin)))
  r0[xx$cell] <- xx$n
  r0
} 

benchmark(PimageRaster = {pall <- px[]}, 
          splatRaster = {sall  <- imgsp2(sx)}, 
          replications  = 10)
#>           test replications elapsed relative user.self sys.self user.child
#> 1 PimageRaster           10    0.49    1.000      0.48     0.00         NA
#> 2  splatRaster           10    0.61    1.245      0.56     0.02         NA
#>   sys.child
#> 1        NA
#> 2        NA

# plot(sqrt(pall), col = palr::sstPal(100))
# plot(sqrt(sall), col = palr::sstPal(100))
```
