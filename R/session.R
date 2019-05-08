##' Attempts to create a new session with the provided arguments.
##'
##' @param location Location of the remote API base endpoint.
##' @param apikey API Key.
##' @param apisecret API Secret.
##' @param token Authentication token.
##' @param profile Profile name.
##' @param config Configuration file path.
##' @param save Indicates if we want to save the session.
##' @return A session.
##'
##' @export
makeSession <- function (location=NULL, apikey=NULL, apisecret=NULL, token=NULL, profile=NULL, config=.defaultConfigFilepath, save=FALSE) {
    ## Attempt to get the profile as the base configuration if defined:
    if (!is.null(profile)) {
        ## Get the profile:
        profile <- readProfile(profile, config)
    }
    else {
        ## Create a dummy profile:
        profile <- list(location=NULL, apikey=NULL, apisecret=NULL, token=NULL)
    }

    ## Overlay actual parameters:
    if (!is.null(location)) {
        profile$location <- location
    }
    if (!is.null(apikey)) {
        profile$apikey <- apikey
    }
    if (!is.null(apisecret)) {
        profile$apisecret <- apisecret
    }
    if (!is.null(token)) {
        profile$token <- token
    }

    ## By now we should have both API key and secret OR token defined. If not, stop!
    if ((is.null(profile$apikey) || is.null(profile$apisecret)) && (is.null(profile$token))) {
        stop("API Key and Secret OR authentication token are not defined.")
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
##' @param location Location of the remote API base endpoint.
##' @param apikey API Key.
##' @param apisecret API Secret.
##' @param token Authentication token.
##' @param profile Profile name.
##' @param config Configuration file path.
##' @param reset Indicates if we are resetting the session first.
##' @return Existing or new session.
##'
##' @export
getSession <- function (location=NULL, apikey=NULL, apisecret=NULL, token=NULL, profile="default", config=.defaultConfigFilepath, reset=FALSE) {
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
        makeSession(location, apikey, apisecret, token, profile, config)
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
