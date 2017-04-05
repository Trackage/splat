## 
as_table_raster <- function(x) {
  tibble(value = values(x), cell = seq(ncell(x))) %>% dplyr::filter(!is.na(value) & value > 0)
}
as_table_pim <- function(x) {
  tibble(value = as.vector(x$p[[1]]$image), cell = cn.pimg(x)) %>% dplyr::filter(!is.na(value) & value > 0)
}
as_table_Pimage <- function(x) {
  dplyr::bind_rows(lapply(seq_along(x), function(i) as_table_pim(x[[i]]) %>% mutate(gmt = as.POSIXct(x)[i])))
}
# as_table_Pimage <- function(x) {
#   dplyr::bind_rows(lapply(seq_along(x), function(i) as_table_raster(x[i]) %>% mutate(gmt = as.POSIXct(x)[i])))
# }
cn.pimg <- function(x) {
  x0 <- x$p[[1]]
  xbnd <- x$xbound
  ybnd <- x$ybound
  offs <- x0$offset
  tl <- ((ybnd[3L] - (offs[2L] + ncol(x0$image))) + 1L) * xbnd[3L] + offs[1L]
  sort(rep(seq(tl, by = xbnd[3], length = ncol(x0$image)), each = nrow(x0$image)) +
         rep(seq_len(nrow(x0$image)) - 1, ncol(x0$image)))
}