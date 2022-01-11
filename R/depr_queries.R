##' Returns the artifact identified by the given identifier.
##'
##' @param id Artifact ID
##' @param session Session which we will retrieve the remote resource within.
##' @return The artifact of interest, if found.
##'
##' @export
getArtifactByID <- function (id, session=NULL) {
    getResource("resources", id, session=session)
}


##' Returns the artifact identified by the given symbol.
##'
##' @param symbol Artifact symbol
##' @param session Session which we will retrieve the remote resource within.
##' @return The artifact of interest, if found.
##'
##' @export
getArtifactBySymbol <- function (symbol, session=NULL) {
    ## Get the search results:
    searchResults <- getResource("resources", params=list(symbol=symbol), session=session)$results

    ## We must have exactly 1 result. Return accordingly:
    if (length(searchResults) != 1) {
        NULL
    }
    else {
        searchResults[[1]]
    }
}


##' Returns the artifact identified by the given identifier or symbol.
##'
##' @param idOrSymbol Artifact ID or symbol
##' @param session Session which we will retrieve the remote resource within.
##' @return The artifact of interest, if found.
##'
##' @export
getArtifact <- function (idOrSymbol, session=NULL) {
    if (is.character(idOrSymbol) && !.isNumeric(idOrSymbol)) {
        getArtifactBySymbol(idOrSymbol)
    }
    else {
        getArtifactByID(idOrSymbol)
    }
}


##' Returns the ledger for the given query.
##'
##' @param artifact The artifact which we want the ledger for.
##' @param accounts Vector of account identifiers.
##' @param start Starting date of the ledger.
##' @param end Ending date of the ledger.
##' @param type Type of date of ledger.
##' @param session Session which we will retrieve the remote resource within.
##' @return A ledger table.
##'
##' @export
getLedger <- function (artifact, accounts, start=NULL, end=NULL, type="commitment", session=NULL) {
    ## Check if the artifact ID by given artifact name or artifact ID:
    if (is.character(artifact) && !.isNumeric(artifact)) {
        artifact <- getArtifact(artifact)$id
    }

    ## Construct the query params:
    params <- list(artifact=artifact, datesmin=start, datesmax=end, datetype=type)

    ## Define accounts param:
    accountParams <- do.call(c, lapply(accounts, function (x) list(accounts=x)))

    ## Add accounts param to params:
    params <- c(params, accountParams)

    ## Done with parameter preparation. Now get the ledger:
    ledgerData <- getResource("ledgers", params=params, session=session)

    ## Tabulate the ledger:
    ledger <- as.data.frame(do.call(rbind, ledgerData$entries))

    ## Check:
    if(NROW(ledger) == 0) {
        return(NULL)
    }

    ## Add date column:
    ledger$date <- ledger[, ledgerData$datetype]

    ## Prepare return value (order columns of interest):
    ledger <- ledger[, c("id", "date", "commitment", "settlement",
                         "account_id", "account__name", "quantity", "balance", "valccy", "valamt",
                         "ctype", "htype", "trade_id", "trade__ctype", "trade__htype")]

    ## Change column names:
    colnames(ledger) <- c("quant", "date", "commitment", "settlement",
                          "accID", "accName", "qty", "balance", "valccy", "valamt",
                          "type", "typeName", "trade", "tradeType", "tradeTypeName")

    ## Done, return the ledger:
    ledger
}

##' Returns the account identified by the given identifier.
##'
##' @param id Account ID
##' @param session Session which we will retrieve the remote resource within.
##' @return The account of interest, if found.
##'
##' @export
getAccountByID <- function (id, session=NULL) {
    getResource("accounts", id, session=session)
}


##' Returns the account identified by the given name.
##'
##' @param name Account name
##' @param session Session which we will retrieve the remote resource within.
##' @return The account of interest, if found.
##'
##' @export
getAccountByName <- function (name, session=NULL) {
    ## Get the search results:
    searchResults <- getResource("accounts", params=list(name=name), session=session)$results

    ## We must have exactly 1 result. Return accordingly:
    if (length(searchResults) != 1) {
        NULL
    }
    else {
        searchResults[[1]]
    }
}


##' Returns the account identified by the given identifier or name.
##'
##' @param idOrName Account ID or name
##' @param session Session which we will retrieve the remote resource within.
##' @return The account of interest, if found.
##'
##' @export
getAccount <- function (idOrName, session=NULL) {
    if (is.character(idOrName) && !.isNumeric(idOrName)) {
        getAccountByName(idOrName)
    }
    else {
        getAccountByID(idOrName)
    }
}
