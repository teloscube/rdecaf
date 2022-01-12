#' Attempts to create DECAF API client credentials from given arguments.
#'
#' @param username Username of "Basic Authentication" method.
#' @param password Password of "Basic Authentication" method.
#' @param apikey API key of "API Key" method.
#' @param apisecret API secret of "API Key" method.
#' @param token Token value of "API Token" method.
#' @param header Authorization header value to be used as is.
#' @return An instance of 'decaf.client.credentials' S3 class with type
#' attribute set to one of `BASIC`, `APIKEY`, `TOKEN` or `HEADER`.
make_credentials <- function(username = NULL, password = NULL, apikey = NULL, apisecret = NULL, token = NULL, header = NULL) { ## nolint
    if (!(is.null(username) || is.null(password))) {
        make_credentials_inner(list(username = username, password = password), type = "BASIC")
    } else if (!(is.null(apikey) || is.null(apisecret))) {
        make_credentials_inner(list(apikey = apikey, apisecret = apisecret), type = "APIKEY")
    } else if (!is.null(token)) {
        make_credentials_inner(list(token = token), type = "TOKEN")
    } else if (!is.null(header)) {
        make_credentials_inner(list(header = header), type = "HEADER")
    } else {
        stop("Can not create DECAF API client credentials with given arguments.")
    }
}

#' 'decaf.client.credentials' S3 class constructor.
#'
#' @param x A named-list of credentials.
#' @param type Type of credentials.
#' @return An instance of 'decaf.client.credentials' S3 class with type
#' attribute set to one of `BASIC`, `APIKEY`, `TOKEN` or `HEADER`.
make_credentials_inner <- function(x, type = c("BASIC", "APIKEY", "TOKEN", "HEADER")) {
    type <- match.arg(type)
    class(x) <- "decaf.client.credentials"
    attr(x, "type") <- type
    x
}

#' Pretty-prints authentication credentials by hiding the actual credentials.
#'
#' @param x An instance of 'decaf.client.credentials' S3 class.
print.decaf.client.credentials <- function(x) { ## nolint
    print(sprintf("<REDACTED DECAF AUTHENTICATION CREDENTIALS (%s)>", attr(x, "type")))
}

#' Builds and returns 'Authorization' header value for the given credentials.
#'
#' @param x An instance of 'decaf.client.credentials' S3 class.
#' @return A character string that can be used as 'Authorization' header value.
make_auth_header_value <- function(x) {
    type <- attr(x, "type")
    if (type == "BASIC") {
        sprintf("Basic %s", jsonlite::base64_enc(sprintf("%s:%s", x$username, x$password)))
    } else if (type == "APIKEY") {
        sprintf("Key %s:%s", x$apikey, x$apisecret)
    } else if (type == "TOKEN") {
        sprintf("Token %s", x$token)
    } else if (type == "HEADER") {
        x$token
    } else {
        stop("Unknown credentials type for DECAF authentication.")
    }
}