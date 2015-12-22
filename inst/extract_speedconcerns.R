#' Extract from an R image list (xyz)
#'
#' Extract pixel values from R's image format.
#'
#' See \code{\link{image}} for details on the format of the grid object.
#' @param g "xyz" \code{list} with \code{x} vector, \code{y} vector and \code{z} matrix
#' @param xy matrix of coordinates with 2 columns, to match x,y vectors in grid
#'
#' @return values extract from grid
#' @export
ext_xyz <- function (g, xy)
{
  csize <- c(diff(g$x[1:2]), diff(g$y[1:2]))
  dimXY <- dim(g$z)

  xs <- xy[, 1]
  ys <- xy[, 2]
  i <- round((1/diff(g$x[1:2])) * (xs - g$x[1]) + 1)
  j <- round((1/diff(g$y[1:2])) * (ys - g$y[1]) + 1)
  f <- rep(as(NA, mode(g$z)), length(xs))
  k <- (i > 0 & j > 0 & i <= dimXY[1] & j <= dimXY[2])
  n <- nrow(xy)
  if (any(k)) {
    f[k] <- g$z[cbind(i[k], j[k])]
  }
  f
}



library(raster)

i <- 2.5
r <- raster(matrix(rnorm(1e6 * i * i), i * 1000))
xy <- matrix(runif(10000), ncol = 2)


xyz_im <- as.image.SpatialGridDataFrame(as(r, "SpatialGridDataFrame"))

b <- brick(r)
library(rbenchmark)

fex1 <- function() {
  extract(r, xy)
}

fex2 <- function() {
  cellFromXY(r, xy)
}

fexb <- function() {
  extract(b, xy)
}
fxyz <- function() {
  ext_xyz(xyz_im, xy)
}


benchmark(ext1 = fex1(),
          ext2 = fex2(),
          fexb = fexb(),
          fxyz = fxyz())
