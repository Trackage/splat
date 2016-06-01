#' splat
#' 
#' @importFrom dplyr data_frame arrange
#' @param x generic
#'
#' @param ... ignored
#' 
#' @importFrom raster projectExtent cellFromXY
#' @export
splat <- function(x, ...) {
 UseMethod("splat")
}

#' splat list
#' @param x fit from SGAT
#'
#' @param grid raster
#' @param proj crs
#' @param ... ignored
#'
#' @export
splat.list<- function(x, grid, proj = NULL, ...) {
  ## check this is a fit from SGAT ...
  xarr <- .chainCollapse(x$x)
  if (missing(grid)) grid <- .chaingrid(xarr)
  .splat3way(xarr, grid)
}

#' @importFrom raster ncell
#' @importFrom dplyr %>% group_by_
.splat3way <- function(x, r0, ...) {
  ntime <- nrow(x)
  niter <- dim(x)[3]
  ncc <- raster::ncell(r0)
  allcells <- seq(ncc)
  l <- vector("list", ntime)
  d0 <- data_frame(cell = allcells)
  for (i in seq_along(l)) {
    l[[i]] <- bind_cols(d0, 
                        data_frame(bin = tabulate(raster::cellFromXY(r0, t(x[i,,])), ncc),  index = rep(i, ncc))
                        ) %>% filter_(quote(bin > 0))
  }
  out <- do.call(bind_rows, l)
  class(out) <- c("splat", class(out))
  attr(out, "grid") <- raster(r0)
  out
}

#' @export
#' @rdname splat
print.splat <- function(x, ...) {
  cat("splat on \n")
  print(attr(x, "grid"))
  attr(x, "grid") <- NULL
  class(x) <- class(x)[-1]
  print(x)
}

#' @export 
#' @rdname splat
show.splat <- print.splat 

#' @export
`[.splat` <- function(x, i, j, ...) {
  #if (missing(j)) print("j is missing")
  #if (missing(i)) print("i is missing")
  print(class(x))
  print(str(i))
  if (is.numeric(i) & missing(j)) {
    ## kick in to rasterize
    r <- attr(x, "grid")
    r <- setValues(r, rep(NA_real_, ncell(r)))
    bins <- filter_(x, quote(index %in% i)) %>% group_by_("index") %>% summarize(count = quote(sum(bin)))
    r[bins$cell] <- bins$count
    return(r)
  }
  NextMethod("[", x)
}


