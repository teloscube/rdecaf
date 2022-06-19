#' @title DECAF API Client
#'
#' @description Instances of this class can be used for conveniently issuing
#' HTTP requests to various APIs of remote DECAF Instances.
#'
#' A DECAF Instance exposes its capabilities and the data it hosts over APIs
#' which can be then consumed by itself (to enhance its feature-set) or 3rd
#' parties (to integrate with 3rd party systems and/or data).
#'
#' The API landscape of DECAF is large and constantly evolving. There are
#' multiple APIs for a given DECAF Instance:
#'
#' 1. DECAF Estate
#' 2. DECAF Microlot
#' 3. DECAF Functions
#' 4. DECAF Beanbag
#' 5. DECAF Barista
#'
#' This class `DecafClient` is a convenience wrapper of individual clients for
#' each of these APIs. However, this class has a property called `bare` that
#' exposes the underlying HTTP client that can be used for all sorts of API
#' calls.
#'
#' Note that we are making use of
#' [crul](https://cran.r-project.org/web/packages/crul/index.html) library (not
#' `curl`) as the underlying HTTP client library. This library is also built
#' using R6 classes. It is very powerful and provides all low-level
#' functionality we needed to implement DECAF API Client(s).
#'
#' @importFrom crul HttpClient
#' @importFrom R6 R6Class
#' @export
DecafClient <- R6::R6Class("DecafClient", ## nolint
    public = list(
        #' @field url Base URL of the remote DECAF Instance.
        url = NULL,

        #' @field bare Bare HTTP client for the remote DECAF Instance.
        #'
        #' This is a `crul::HttpClient` instance that is ready to issue requests
        #' to remote DECAF Instance. Indeed, this instance is sufficient for any
        #' kind of API communication with remote DECAF Instance.
        #'
        #' The API namespace is not provided. Therefore, the call-site needs to
        #' pass the absolute URL path (such as `/api/version/`) when using this
        #' bare HTTP client.
        bare = NULL,

        #' @description Creates a DECAF client.
        #'
        #' @param url Base URL of the remote DECAF instance.
        #' @param credentials Authentication credentials for the remote DECAF
        #' instance.
        #'
        #' This should be a named-list of credentials. Key-value pairs of this
        #' list depends on the authentication method. Keys should be one of:
        #'
        #' 1. `username` and `password` for "Basic Authentication" method.
        #' 2. `apikey` and `apisecret` for "API Key Authentication" method.
        #' 3. `token` for "API Token Authentication" method.
        #' 4. `header` for passing `Authorization` HTTP header as is.
        #' @return A new `DecafClient` object.
        #' @examples
        #' client <- rdecaf::DecafClient$new(
        #'     url = "https://httpbin.org",
        #'     credentials = list(username = "hebele", password = "hubele")
        #' )
        #' client <- rdecaf::DecafClient$new(
        #'     url = "https://httpbin.org",
        #'     credentials = list(apikey = "hebele", apisecret = "hubele")
        #' )
        #' client <- rdecaf::DecafClient$new(
        #'     url = "https://httpbin.org",
        #'     credentials = list(token = "zamazingo")
        #' )
        #' client <- rdecaf::DecafClient$new(
        #'     url = "https://httpbin.org",
        #'     credentials = list(header = "Token zamazingo")
        #' )
        initialize = function(url, credentials) {
            self$url <- url
            private$credentials <- do.call(make_credentials, as.list(credentials))
            private$setup()
        },

        #' @description Prints rudimentary information about the DECAF Instance.
        info = function() {
            cat(sprintf("DECAF Instance Base URL         : %s\n", self$url))
            cat(sprintf("DECAF Instance Credentials Type : %s\n", private$credentials_type()))
        },

        #' @description Provides the print function for `DecafClient` object.
        print = function() {
            print(sprintf("<DECAF CLIENT (url = %s, credentials type = %s)>", self$url, private$credentials_type()))
        }
    ),
    private = list(
        ## Authentication credentials for the remote DECAF instance.
        credentials = NULL,

        ## Setups this instance.
        setup = function() {
            self$bare <- crul::HttpClient$new(
                url = self$url,
                headers = c(
                    build_http_header_authorization(private$credentials),
                    build_http_header_user_agent(),
                    build_http_header_x_decaf_url(self$url)
                )
            )
        },

        ## Returns the credentials type.
        credentials_type = function() {
            attr(private$credentials, "type")
        }
    )
)

#' Builds and returns the "Authorization" HTTP header for the HTTP calls
#' originating from this library.
#'
#' @param credentials An instance of 'decaf.client.credentials' S3 class.
#' @return A named-list for `Authorization` key-value pair.
build_http_header_authorization <- function(credentials) {
    list(
        Authorization = make_auth_header_value(credentials)
    )
}

#' Builds and returns the "User-Agent" HTTP header for the HTTP calls
#' originating from this library.
#'
#' @return A named-list for `User-Agent` key-value pair.
build_http_header_user_agent <- function() {
    list(
        "User-Agent" = sprintf(
            "rdecaf/%s (%s; on:%s)",
            utils::packageVersion("rdecaf"),
            Sys.info()["sysname"],
            Sys.info()["nodename"]
        )
    )
}

#' Builds and returns the "X-DECAF-URL" HTTP header for the HTTP calls
#' originating from this library.
#'
#' For historical reasons, this function also adds `X-DECAF-APIURL` and
#' `X-DECAF-API-URL` headers, too. These will be removed at some point in the
#' future.
#'
#' @param url Base URL of the remote DECAF Instance.
#' @return A named-list for `X-DECAF-URL`, `X-DECAF-APIURL` and
#' `X-DECAF-API-URL` key-value pairs.
build_http_header_x_decaf_url <- function(url) {
    list(
        "X-DECAF-URL" = url, ## This is the way forward.
        "X-DECAF-APIURL" = sprintf("%s/api", url), ## Deprecated. Use X-DECAF-URL instead.
        "X-DECAF-API-URL" = sprintf("%s/api", url) ## Deprecated. Use X-DECAF-URL instead.
    )
}