---
output:
  md_document:
    variant: markdown_github
---

<!-- README.md is generated from README.Rmd. Please edit that file -->





## R Markdown


```r
load("data/082_WI_MARCH2013fitSST.RData")
library(raster)
x <- SGAT::Pimage(fit, proj = NULL)
library(splat)
#> 
#> Attaching package: 'splat'
#> 
#> The following objects are masked _by_ '.GlobalEnv':
#> 
#>     fit, splat
sx <- splat(x)

library(dplyr)

g <- setValues(x[], NA_real_)
g1 <- g
system.time({
  sgg <- sx$pix  %>% group_by(cell) %>% summarize(bin = sum(bin))
  g1[sgg$cell] <- sgg$bin
})
#> Error in UseMethod("group_by_"): no applicable method for 'group_by_' applied to an object of class "NULL"
#> Timing stopped at: 0 0 0

system.time({
  g2 <- x[]
})
#>    user  system elapsed 
#>    0.05    0.00    0.05

## much simpler and almost as fast
g <- SGAT:::.chaingrid(SGAT::chainCollapse(fit$x))
g1 <- g
system.time({
x <- splatchain(g, SGAT::chainCollapse(fit$x))
xs <- x  %>% group_by(cell)  %>%  summarize(bin = sum(bin))
g1[xs$cell] <- xs$bin
})
#>    user  system elapsed 
#>    2.90    0.04    2.98
system.time({
g2 <- SGAT::Pimage(fit, grid = g)[]
})
#>    user  system elapsed 
#>    2.24    0.14    2.40
```
