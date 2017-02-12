##' @import httr
.getToken <- function (location, username, password) {
    ## Check arguments:
    if (any(sapply(c(location, username, password), is.null))) {
        stop("Base URL Path, username and password must be provided for getting an API token.")
    }

    ## Create the URL:
    url <- .urlize(location, c("auth", "token"))

    ## Attempt to get token response:
    response <- httr::POST(url, body=list(username=username, password=password))

    ## Get the status:
    status <- response$status_code

    ## If the status code is not 200, raise an error:
    if (status == 400) {
        stop("Authentication failed with the provided credentials.")
    }
    else if (status != 200) {
        stop(sprintf("%s returned a status code of '%d'.\n\n  Details provided by the API are:\n\n%s", url, status, httr::content(response)))
    }

    ## Return the token:
    httr::content(response)$token
}


##' Attempts to create a new session with the provided arguments.
##'
##' @param location The location of the remote API base endpoint.
##' @param token Authentication token.
##' @param username Username.
##' @param password Password.
##' @param profile The profile name.
##' @param config The configuration file path.
##' @param save Indicates if we want to save the session.
##' @return A session.
##'
##' @export
makeSession <- function (location=NULL, token=NULL, username=NULL, password=NULL, profile="default", config=.defaultConfigFilepath, save=FALSE) {
    ## Attempt to get the profile as the base configuration if defined:
    if (!is.null(profile)) {
        ## Get the profile:
        profile <- readProfile(profile, config)
    }
    else {
        ## Create a dummy profile:
        profile <- list(location=NULL, token=NULL, username=NULL, password=NULL)
    }

    ## Overlay actual parameters:
    if (!is.null(location)) {
        profile$location <- location
    }
    if (!is.null(token)) {
        profile$token <- token
    }
    if (!is.null(username)) {
        profile$username <- username
    }
    if (!is.null(password)) {
        profile$password <- password
    }

    ## If token is not defined, attempt to get a token from remote API:
    if (is.null(token)) {
        profile$token <- .getToken(profile$location, profile$username, profile$password)
    }

    ## Save the session if required:
    if (save) {
        options(rdecaf.session=profile)
    }

    ## Return the session:
    profile
}


##' Gets or creates a session.
##'
##' @param location The API Base URL.
##' @param token The API authentication token.
##' @param username The API authentication credential for username.
##' @param password The API authentication credential for password.
##' @param profile Profile name.
##' @param config The file path of the configuration.
##' @param reset Indicates if we are resetting the session first.
##' @return Existing or new session.
##'
##' @export
getSession <- function (location=NULL, token=NULL, username=NULL, password=NULL, profile="default", config=.defaultConfigFilepath, reset=FALSE) {
    ## Reset or not?
    if (reset) {
        deleteSession()
    }

    ## First, attempt to get the session:
    session <- try(readSession(), silent=TRUE)

    ## Is it error?
    if(!inherits(session, "try-error")) {
        ## Nope, return the session:
        session
    }
    else {
        ## Attempt to create a session:
        makeSession(location, token, username, password, profile, config)
    }
}


##' Attempts to read the session from options
##'
##' Stops if no existing session is found.
##'
##' @return Session found.
##'
##' @export
readSession <- function () {
    ## Attempt to get the session:
    session <- getOption("rdecaf.session")

    ## Do we have a session?
    if (is.null(session)) {
        stop("No existing session found.")
    }

    ## Return the session:
    session
}


##' Deletes the current session.
##'
##' @return Nothing.
##' @export
deleteSession <- function () {
    options(rdecaf.session=NULL)
}
