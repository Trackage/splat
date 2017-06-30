
mk_map <- function(tab,  grid, mask = NULL) {
  tab <- tab %>% 
    group_by(cell) %>% 
    summarize(timespent = sum(value))
  wmap <- setValues(grid, NA_real_)
  wmap[tab$cell] <- tab$timespent
  if (!is.null(mask)) wmap[is.na(mask)] <- NA_real_
  wmap
}
