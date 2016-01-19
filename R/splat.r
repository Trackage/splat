#' @importFrom raster cellFromXY
splatbin <- function(grid, xy, weight = NULL, previters = 0) {
  summ <- data_frame(cell = cellFromXY(grid, xy), bin = 1) %>%
    group_by(cell) %>%
    summarize(bin = sum(bin))
}


splatchain <- function(grid, chain) {
  l <- vector("list", nrow(chain))
  for (i in seq_along(l)) l[[i]] <- splatbin(grid, t(chain[i,,]))
  do.call(bind_rows, l)
}

cellnumber.pimg <- function (x) 
{
  xbnd <- x$xbound
  ybnd <- x$ybound
  offs <- x$p[[1]]$offset
  img <- x$p[[1]]$image
  tl <- ((ybnd[3L] - (offs[2L] + ncol(img))) + 1L) * xbnd[3L] + 
    offs[1L]
  sort(rep(seq(tl, by = xbnd[3], length = ncol(img)), each = nrow(img)) + 
         rep(seq_len(nrow(img)) - 1, ncol(img)))
}


#' Title
#'
#' @param x Pimage
#' @param proj PROJ.4 string, optional
#'
#' @return list of data_frames
#' @export
#' @importFrom dplyr data_frame row_number %>%  filter_
splat <- function(x, proj = NULL) {
  allbins <- allcells <- vector("list", length(x$p))


  for (i in seq_along(allcells)) {
    allcells[[i]] <- cellnumber.pimg(x[[i]])
    allbins[[i]] <- as.vector(x[[i]]$p[[1]]$image)
  }
  index <- lapply(seq_along(allcells), function(xa) rep(xa, length(allcells[[xa]])))
  pix <- dplyr::data_frame(cell = as.integer(unlist(allcells)), index = as.integer(unlist(index)), bin = as.integer(unlist(allbins)))
  time <- dplyr::data_frame(time = SGAT:::as.POSIXct.Pimage(x), index = as.integer(seq(length(x))))
  ## filter out zeroes and the performance via dplyr is pretty close
  list(pixel = pix %>% dplyr::filter_("bin > 0"), time = time)
}

