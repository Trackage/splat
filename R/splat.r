

#' Title
#'
#' @param x Pimage
#' @param proj PROJ.4 string, optional
#'
#' @return list of data_frames
#' @export
#' @importFrom dplyr data_frame row_number
splat <- function(x, proj = NULL) {
  allbins <- allcells <- vector("list", length(x))


  for (i in seq_along(allcells)) {
    allcells[[i]] <- SGAT:::cn.pimg(x[[i]])
    allbins[[i]] <- as.vector(x[[i]]$p[[1]]$image)
  }
  index <- lapply(seq_along(allcells), function(xa) rep(xa, length(allcells[[xa]])))
  pix <- data_frame(cell = unlist(allcells), index = unlist(index), bin = unlist(allbins))
  time <- data_frame(time = SGAT:::as.POSIXct.Pimage(x), index = seq(length(x)))
  ## filter out zeroes and the performance via dplyr is pretty close
  list(pixel = pix %>% filter(bin > 0), time = time)
}

