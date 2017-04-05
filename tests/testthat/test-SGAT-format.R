context("SGAT-format")

## TODO: Rename context
## TODO: Add more tests
if (file.exists("/mnt/SGAT/fit/004_WI_MARCH2014fitSST.RData")) {
  load("/mnt/SGAT/fit/004_WI_MARCH2014fitSST.RData")
  test_that("fit object has what we expect", {
    expect_equal(names(fit), c("model", "x", "z"))
  })


tfile <- sprintf("%.sgat", tempfile())
test_that(create_sgat(tfile), is_a("db thinga"))


}