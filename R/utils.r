.gperm <- function (x, perm) 
{
  dm <- dim(x)
  x <- aperm(x, unlist(perm))
  dim(x) <- sapply(perm, function(k) prod(dm[k]))
  x
}
#' @importFrom raster raster  
.chaingrid <- function (x) 
{
  xrange <- range(x[, 1, ])
  yrange <- range(x[, 2, ])
  xrange <- xrange + c(-1, 1) * (diff(xrange)/10)
  yrange <- yrange + c(-1, 1) * (diff(yrange)/10)
  raster(nrows = 300, ncols = 300, xmn = xrange[1L], xmx = xrange[2L], 
         ymn = yrange[1L], ymx = yrange[2L], crs = "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0")
}

.projIsLonLat <- function(x) grepl("longlat", x) || grepl("lonlat", x)
.chainCollapse <- 
function (s, collapse = TRUE, discard = 0, thin = 1, chains = NULL) 
{
  subset <- function(s) s[, , seq.int(from = 1 + max(discard, 
                                                     0), to = dim(s)[3L], by = thin)]
  if (!is.list(s)) {
    if (thin > 1 || discard > 0) 
      s <- subset(s)
  }
  else {
    if (!is.null(chains)) 
      s <- s[chains]
    if (thin > 1 || discard > 0) 
      s <- lapply(s, subset)
    if (collapse) {
      dm <- dim(s[[1]])
      s <- array(unlist(s), c(dm[1:2], length(s) * dm[3]))
    }
  }
  s
}