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
