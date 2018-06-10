.authorizationHeader <- function (session) {
    ## There are two possibilies about the authorization type:
    ##
    ## 1. Session contains the "token" property in which case we will
    ## attempt using it.
    ##
    ## 2. Session contains both the apikey and apisecret which we can
    ## fallback to.
    if (!is.null(session$token) && !is.na(session$token)) {
        paste0("TOKEN ", session$token)
    }
    else {
        ## TODO: Ensure that we have both the apikey and apisecret.
        paste0("KEY ", session$apikey, ":", session$apisecret)
    }
}

##' Retrieve a resource from DECAF API.
##'
##' @param ... URL path segments.
##' @param params Query parameters.
##' @param session Session information.
##' @return Parsed R object for the response.
##'
##' @import httr
##' @import readr
##' @export
getResource <- function (..., params=list(), session=NULL) {
    ## Get or create a session:
    if (is.null(session)) {
        session <- readSession()
    }

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
    response <- httr::GET(url, httr::add_headers(Authorization=.authorizationHeader(session)))

    ## Get the status:
    status <- response$status_code

    ## If the status code is not 200, raise an error:
    if (status != 200) {
        stop(sprintf("%s returned a status code of '%d'.\n\n  Details provided by the API are:\n\n%s", url, status, httr::content(response, as="text")))
    }

    ## Return (note that we are suppressing messages):
    suppressMessages(httr::content(response))
}


##' Send a resource to DECAF API.
##'
##' @param ... URL path segments.
##' @param params Query parameters.
##' @param payload The payload to be send.
##' @param session Session information.
##' @return Parsed R object for the response.
##'
##' @import httr
##' @import readr
##' @export
postResource <- function (..., params=list(), payload=NULL, session=NULL) {
    ## Get or create a session:
    if (is.null(session)) {
        session <- readSession()
    }

    ## Get the base url to start to build the endpoint URL:
    url <- httr::parse_url(session$location)

    ## Add paths ensuring that path seperator is not duplicated and a
    ## trailing path seperator is added:
    url$path <- c(sub("/$", "", gsub("//", "/", c(url$path, ...))), "/")

    ## Add params:
    url$query <- params

    ## Construct the endpoint URL:
    url <- httr::build_url(url)

    ## Post the resource:
    response <- httr::POST(url, httr::add_headers(Authorization=.authorizationHeader(session), "Content-Type"="application/json"), body=payload)

    ## Get the status:
    status <- response$status_code

    ## If the status code is not 200, raise an error:
    if (status >= 300) {
        stop(sprintf("%s returned a status code of '%d'.\n\n  Details provided by the API are:\n\n%s", url, status, httr::content(response, as="text")))
    }

    ## Return:
    httr::content(response)
}


##' Update a resource to DECAF API.
##'
##' @param ... URL path segments.
##' @param params Query parameters.
##' @param payload The payload to be send.
##' @param session Session information.
##' @return Parsed R object for the response.
##'
##' @import httr
##' @import readr
##' @export
putResource <- function (..., params=list(), payload=NULL, session=NULL) {
    ## Get or create a session:
    if (is.null(session)) {
        session <- readSession()
    }

    ## Get the base url to start to build the endpoint URL:
    url <- httr::parse_url(session$location)

    ## Add paths ensuring that path seperator is not duplicated and a
    ## trailing path seperator is added:
    url$path <- c(sub("/$", "", gsub("//", "/", c(url$path, ...))), "/")

    ## Add params:
    url$query <- params

    ## Construct the endpoint URL:
    url <- httr::build_url(url)

    ## Put the resource:
    response <- httr::PUT(url, httr::add_headers(Authorization=.authorizationHeader(session), "Content-Type"="application/json"), body=payload)

    ## Get the status:
    status <- response$status_code

    ## If the status code is not 200, raise an error:
    if (status != 200) {
        stop(sprintf("%s returned a status code of '%d'.\n\n  Details provided by the API are:\n\n%s", url, status, httr::content(response, as="text")))
    }

    ## Return:
    httr::content(response)
}


##' Partially update a resource to DECAF API.
##'
##' @param ... URL path segments.
##' @param params Query parameters.
##' @param payload The payload to be send.
##' @param session Session information.
##' @return Parsed R object for the response.
##'
##' @import httr
##' @import readr
##' @export
patchResource <- function (..., params=list(), payload=NULL, session=NULL) {
    ## Get or create a session:
    if (is.null(session)) {
        session <- readSession()
    }

    ## Get the base url to start to build the endpoint URL:
    url <- httr::parse_url(session$location)

    ## Add paths ensuring that path seperator is not duplicated and a
    ## trailing path seperator is added:
    url$path <- c(sub("/$", "", gsub("//", "/", c(url$path, ...))), "/")

    ## Add params:
    url$query <- params

    ## Construct the endpoint URL:
    url <- httr::build_url(url)

    ## Patch the resource:
    response <- httr::PATCH(url, httr::add_headers(Authorization=.authorizationHeader(session), "Content-Type"="application/json"), body=payload)

    ## Get the status:
    status <- response$status_code

    ## If the status code is not 200, raise an error:
    if (status >= 300) {
        stop(sprintf("%s returned a status code of '%d'.\n\n  Details provided by the API are:\n\n%s", url, status, httr::content(response, as="text")))
    }

    ## Return:
    httr::content(response)
}


##' Delete a resource to DECAF API.
##'
##' @param ... URL path segments.
##' @param params Query parameters.
##' @param session Session information.
##' @return Parsed R object for the response.
##'
##' @import httr
##' @import readr
##' @export
deleteResource <- function (..., params=list(), session=NULL) {
    ## Get or create a session:
    if (is.null(session)) {
        session <- readSession()
    }

    ## Get the base url to start to build the endpoint URL:
    url <- httr::parse_url(session$location)

    ## Add paths ensuring that path seperator is not duplicated and a
    ## trailing path seperator is added:
    url$path <- c(sub("/$", "", gsub("//", "/", c(url$path, ...))), "/")

    ## Add params:
    url$query <- params

    ## Construct the endpoint URL:
    url <- httr::build_url(url)

    ## Delete the resource:
    response <- httr::DELETE(url, httr::add_headers(Authorization=.authorizationHeader(session), "Content-Type"="application/json"))

    ## Get the status:
    status <- response$status_code

    ## If the status code is not 200, raise an error:
    if (status >= 300) {
        stop(sprintf("%s returned a status code of '%d'.\n\n  Details provided by the API are:\n\n%s", url, status, httr::content(response, as="text")))
    }

    ## Return:
    httr::content(response)
}
