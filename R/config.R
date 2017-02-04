## Defines the home directory of the user.
.homeDirectory <- path.expand("~")


## Defines the path to the default configuration file.
.defaultConfigFilepath <- file.path(.homeDirectory, ".decaf.json")


##' Reads and returns the configuration file.
##'
##' @param filepath The path to the configuration file.
##' @return Configuration if configuration file is read successfully,
##'     stops with error otherwise.
##'
##' @import jsonlite
##' @export
readConfig <- function (filepath=.defaultConfigFilepath) {
    ## Check if the file exists:
    if (!file.exists(filepath)) {
        stop(sprintf("Configuration file '%s' could not be found.", filepath))
    }

    ## Read and return:
    jsonlite::fromJSON(filepath)
}


##' Reads profiles from the configuration file and returns them.
##'
##' @param filepath The path to the configuration file.
##' @return List of profiles if configuration file is read successfully,
##'     stops with error otherwise.
##'
##' @export
readProfiles <- function (filepath=.defaultConfigFilepath) {
    ## Attempt to read the configuration file:
    config <- readConfig(filepath)

    ## Check if profiles are provided:
    if (is.null(config$profiles)) {
        stop(sprintf("No profiles found in the configuration file '%s'", filepath))
    }

    ## Return:
    config$profiles
}


##' Reads a profile from the configuration file and returns it.
##'
##' @param name The name of the profile.
##' @param filepath The path to the configuration file.
##' @return The profile if configuration file is read and profile is
##'     retrieved successfully, stops with error otherwise.
##'
##' @export
readProfile <- function (name="default", filepath=.defaultConfigFilepath) {
    ## Attempt to read profile first:
    profile <- readProfiles(filepath)[[name]]

    ## Check if profile is found:
    if (is.null(profile)) {
        stop(sprintf("Profile '%s' is not found in the configuration file '%s'", name, filepath))
    }

    ## Define required fields in the profile:
    required <- c("location", "username", "password")

    ## Check if profile is complete:
    if (!all(required %in% names(profile))) {
        stop(sprintf("Profile '%s' does not contain all required parameters (%s).", name,  do.call(paste, c(as.list(required), sep=", "))))
    }

    ## Return:
    profile
}
