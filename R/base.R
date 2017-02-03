## Defines the global section key used for rdecaf configuration in options().
.optionsSectionKey <- "rdecaf"

## Defines the home directory of the user.
.homeDirectory <- path.expand("~")

## Defines the path to the default configuration file.
.defaultConfigurationFilepath <- file.path(.homeDirectory, ".decaf.json")

.getProfilesFromOptions <- function () {
    ## Attempt to get profiles from options and return:
    getOption(paste0(.optionsSectionKey, ".profiles"))
}

##' @import jsonlite
.getProfilesFromFile <- function () {
    ## Check if the file exists:
    if (file.exists(.defaultConfigurationFilepath)) {
        jsonlite::fromJSON(.defaultConfigurationFilepath)
    }
    else {
        NULL
    }
}

.getProfiles <- function () {
    ## Profiles can be in two different locations:
    ##
    ## 1. In the current R session accessible via `options()`.
    ## 2. In the configuration file located at "${HOME}/.decaf.json"
    ##
    ## The current session overrides the configuration file option.
    ##
    ## Attempt first to get from options:
    profiles <- .getProfilesFromOptions()

    ## If we have any, return. Otherwise, attempt to get from
    ## configuration file.
    if (!is.null(profiles)) {
        ## Yep, we have profiles. Return:
        profiles
    }
    else {
        ## We don't have any profiles. Read from file:
        profiles <- .getProfilesFromFile()

        ## If we have any profiles now, set to options and return:
        if (!is.null(profiles)) {
            ## Get the key:
            key <- paste0(.optionsSectionKey, ".profiles")

            ## Argument:
            args <- list()
            args[[key]] <- profiles$profiles

            ## Set:
            do.call(options, args)
            getOption(key)
        }
        else {
            NULL
        }
    }
}

.getProfile <- function (name="default") {
    ## First, get the profiles:
    profiles <- .getProfiles()

    ## Get the profile:
    profile <- profiles[[name]]

    ## Check:
    if (is.null(profile)) {
        stop(sprintf("No profile found by name '%s'", name))
    }
    else {
        profile
    }
}

.getLocation <- function (profile="default") {
    .getProfile(profile)$location
}

.getUsername <- function (profile="default") {
    .getProfile(profile)$username
}

.getPassword <- function (profile="default") {
    .getProfile(profile)$password
}

.getConfiguration <- function (location=NULL, username=NULL, password=NULL, profile=NULL) {
    ## Get location, username and password:
    location <- ifelse(!is.null(location), location, .getLocation(profile))
    username <- ifelse(!is.null(username), username, .getUsername(profile))
    password <- ifelse(!is.null(password), password, .getPassword(profile))

    ## Pack and return:
    list(location=location, username=username, password=password, baseurl=httr::parse_url(location))
}

##' Retrieve a resource from DECAF API.
##'
##' @param ... URL path segments.
##' @param params Query parameters.
##' @param location Base URL of the API.
##' @param username Username.
##' @param password Password.
##' @param profile Profile name.
##' @return Parsed R object for the response.
##'
##' @import httr
##' @import readr
##' @export
getResource <- function (..., params=list(), location=NULL, username=NULL, password=NULL, profile=NULL) {
    ## Get the configuration:
    configuration <- .getConfiguration(location, username, password, profile)

    ## Get the base url to start to build the endpoint URL:
    url <- configuration$baseurl

    ## Add paths ensuring that path seperator is not duplicated and a
    ## trailing path seperator is added:
    url$path <- c(sub("/$", "", gsub("//", "/", c(url$path, ...))), "/")

    ## Add params:
    url$query <- params

    ## Construct the endpoint URL:
    url <- httr::build_url(url)

    ## Get the resource:
    response <- httr::GET(url, httr::authenticate(configuration$username, configuration$password))

    ## Get the status:
    status <- response$status_code

    ## If the status code is not 200, raise an error:
    if (status != 200) {
        stop(sprintf("%s returned a status code of '%d'.\n\n  Details provided by the API are:\n\n%s", url, status, httr::content(response)))
    }

    ## Return:
    httr::content(response)
}
