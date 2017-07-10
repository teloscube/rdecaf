##' Defines a vector of types which we are not interesting in getting OHLC Observations for.
.excludeTypes <- c("CCY", "DEPO", "LOAN", "FWD", "FXFWD", "DCIP", "ELNP", "INSR", "COMM")


##' Returns a list of symbols of interest for retrieving OHLC
##' Observations for.
##'
##' @param session Session data to communicate with DECAF server.
##' @return A character vector of symbols.
##'
##' @import stats
##' @export
getSymbolsOfInterest <- function (session=NULL) {
    ## Get symbol and OHLC Code from artifacts:
    fromArtifacts <- getResource("resources", params=list(format="csv", page_size=-1, "_fields"="ctype,symbol,ohlccode"), session=session)

    ## Get all OHLC Codes first:
    ohlccodes <- unique(stats::na.omit(fromArtifacts$ohlccode))

    ## For the symbols, remove
    symbols <- fromArtifacts$symbol[!(fromArtifacts$ctype %in% .excludeTypes)]

    ## Done, return:
    unique(c(symbols, ohlccodes))
}


##' Uploads a data frame of OHLC observations to the system.
##'
##' The \code{observations} argumens must be a data frame with
##' \code{date}, \code{symbol} and \code{close} columns. Additionally
##' and optionally it can include \code{open}, \code{high},
##' \code{low}, \code{volume} and \code{interest} columns.
##'
##' @param observations Observations.
##' @param session Session data to communicate with DECAF server.
##' @return Result of uploading.
##'
##' @import plyr
##' @import jsonlite
##' @export
uploadOHLC <- function (observations, session=NULL) {
    ## Define the data structure:
    struct <- data.frame(symbol=character(),
                         date=character(),
                         open=numeric(),
                         high=numeric(),
                         low=numeric(),
                         close=numeric(),
                         volume=numeric(),
                         interest=numeric())

    ## Combine data:
    combined <- plyr::rbind.fill(struct, observations)[, c("symbol", "date", "open", "high", "low", "close", "volume", "interest")]

    ## Remove observation for which symbol, date and close are not available:
    exclude <- is.na(combined$symbol) | is.null(combined$symbol) | is.na(combined$date) | is.null(combined$date) | is.na(combined$close) | is.null(combined$close)
    combined <- combined[!exclude, ]

    ## Make sure that dates are OK:
    as.Date(combined$date)

    ## Get the data as JSON:
    postResource("ohlcobservations", "updatebulk", payload=jsonlite::toJSON(combined))
}
