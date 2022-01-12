#' Finds and returns the value(s) of the given case-insensitive header name for
#' the given named-list of HTTP headers.
#'
#' @param headers A named-list of header name/value tuples.
#' @param name Header name.
#' @return A vector of values.
get_header_value <- function(headers, name) {
    ## Sanitize header name:
    name <- trimws(as.character(name))

    ## Check for empty header name:
    stopifnot(name != "")

    ## Attempt to get the indices for the values matching the name (case-insensitive):
    idx <- which(grepl(name, names(headers), ignore.case = TRUE))

    ## If there is no match, return empty vector, matching header values otherwise:
    if (length(idx) == 0) {
        c()
    } else {
        unlist(headers[idx], use.names = FALSE)
    }
}