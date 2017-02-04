##' Retrieve a resource from DECAF API.
##'
##' @param ... URL path segments.
##' @param params Query parameters.
##' @param location Base URL of the API.
##' @param token Authentication token.
##' @param username Username.
##' @param password Password.
##' @param profile Profile name.
##' @param config Path to configuration file.
##' @return Parsed R object for the response.
##'
##' @import httr
##' @import readr
##' @export
getResource <- function (..., params=list(), location=NULL, token=NULL, username=NULL, password=NULL, profile="default", config=.defaultConfigFilepath) {
    ## Get or create a session:
    session <- getSession(location, token, username, password, profile, config)

    ## Get the base url to start to build the endpoint URL:
    url <- httr::parse_url(session$location)

    ## Add paths ensuring that path seperator is not duplicated and a
    ## trailing path seperator is added:
    url$path <- c(sub("/$", "", gsub("//", "/", c(url$path, ...))), "/")

    ## Add params:
    url$query <- params

    ## Construct the endpoint URL:
    url <- httr::build_url(url)

    ## Get the resource:
    response <- httr::GET(url, httr::add_headers(Authorization=paste("Token", session$token)))

    ## Get the status:
    status <- response$status_code

    ## If the status code is not 200, raise an error:
    if (status != 200) {
        stop(sprintf("%s returned a status code of '%d'.\n\n  Details provided by the API are:\n\n%s", url, status, httr::content(response)))
    }

    ## Return:
    httr::content(response)
}
