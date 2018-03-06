## Load the library:
devtools::load_all(".")

## Create a session:
makeSession(profile="localhost", save=TRUE)

## Get version:
version <- getResource("version")

## Get USD artifact by symbol:
USD1 <- getArtifactBySymbol("USD")

## Get USD artifact by ID:
USD2 <- getArtifactByID(USD1$id)

## Get USD artifact by symbol or ID:
USD3 <- getArtifact("USD")
USD4 <- getArtifact(USD1$id)

## Get the ledger for USD on account identified by `1`:
ledger <- getLedger("USD", c())

## Attempt to get the team identified by the name:
team <- try(getResource("teams", params=list(name="TEAM X", page_size=-1))[[1]], silent=TRUE)

## Do we have the team?
if (class(team) == "try-error") {
    ## Nope, create it:
    team <- postResource("teams", payload=jsonlite::toJSON(list(name="TEAM X", members=I(2)), auto_unbox=TRUE))
}

## Change the name:
team <- patchResource("teams", team$id, payload=jsonlite::toJSON(list(name="TEAM Z"), auto_unbox=TRUE))

## Re-get the resource:
team <- getResource("teams", params=list(name="TEAM Z", page_size=-1))[[1]]

## Delete the resource:
team <- deleteResource("teams", team$id)
