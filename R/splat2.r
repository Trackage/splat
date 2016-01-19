
#' @importFrom dplyr data_frame arrange
#' @importFrom raster projectExtent cellFromXY
#' @export
splat <- function(x, ...) UseMethod("splat")

#' @export
splat.list<- function(x, grid, proj = NULL, ...) {
  ## check this is a fit from SGAT ...
  xarr <- .chainCollapse(x$x)
  if (missing(grid)) grid <- .chaingrid(xarr)
 # if (!is.null(proj) & !.projIsLonLat(proj)) {
#    grid <- raster::projectExtent(grid, proj)
 # }
  ## determine method (or just do both)
  #xarr <- .chainCollapse(x$x)
  .splat3way(xarr, grid)
}

.splat3way <- function(x, r0, ...) {
  ntime <- nrow(x)
  niter <- dim(x)[3]
  ncc <- ncell(r0)
  allcells <- seq(ncc)
  l <- vector("list", ntime)
  d0 <- data_frame(cell = allcells)
  for (i in seq_along(l)) {
    l[[i]] <- bind_cols(d0, 
                        data_frame(bin = tabulate(raster::cellFromXY(r0, t(x[i,,])), ncc),  index = rep(i, ncc))
                        ) %>% filter(bin > 0)
  }
  do.call(bind_rows, l)
  #data_frame(cell = raster::cellFromXY(r0, .gperm(x, list(c(1, 3), 2))), 
  #                index = rep(seq(ntime), niter)) %>% group_by(cell, index) ##%>% arrange(index)
}

