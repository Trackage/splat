find_modal_loc <- function(x) {
  idx <- seq_along(x)
  r <- x[]
  xy <- do.call(rbind, lapply(idx, function(a) {
    pp <- SGAT:::subset.Pimage(im, a)
    cell <- cn.pimg(pp)[which.max(as.vector(pp$p[[1]]$image))]
    xyFromCell(r, cell)
  }))
  data.frame(x = xy[, 1], y = xy[, 2], time = as.POSIXct(x))
  
}
