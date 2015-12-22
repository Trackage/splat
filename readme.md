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
sx <- splat(x)

library(dplyr)

g <- setValues(x[], NA_real_)
g1 <- g
system.time({
  sgg <- sx$pix  %>% group_by(cell) %>% summarize(bin = sum(bin))
  g1[sgg$cell] <- sgg$bin
})
#>    user  system elapsed 
#>    0.07    0.00    0.08

system.time({
  g2 <- x[]
})
#>    user  system elapsed 
#>    0.05    0.00    0.04
```
