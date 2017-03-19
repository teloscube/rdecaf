##' Indicates if the given argument is all numeric.
##'
##' @param x Argument to be checked.
##' @return Logical indicating if the argument is numeric or not.
.isNumeric <- function (x) {
    suppressWarnings(all(!is.na(as.numeric(x))))
}


##' Make a URL.
##'
##' @param baseurl Base URL.
##' @param segments A vector of URL segments.
##' @param params Query string parameters.
##' @return URL.
.urlize <- function (baseurl, segments, params=NULL) {
    ## Deconstruct the base url:
    url <- httr::parse_url(baseurl)

    ## Add paths ensuring that path seperator is not duplicated and a
    ## trailing path seperator is added:
    url$path <- c(sub("/$", "", gsub("//", "/", c(url$path, segments))), "/")

    ## Add params:
    url$query <- params

    ## Re-construct the URL and return:
    httr::build_url(url)
}
