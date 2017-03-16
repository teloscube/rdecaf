## Load the library:
devtools::load_all(".")

## Create a session:
makeSession(profile="localhost", save=TRUE)

## Get version:
#version <- getResource("version")

## Get USD artifact by symbol:
#USD1 <- getArtifactBySymbol("USD")

## Get USD artifact by ID:
#USD2 <- getArtifactByID(USD1$id)

## Get USD artifact by symbol or ID:
#USD3 <- getArtifact("USD")
#USD4 <- getArtifact(USD1$id)

## Get the ledger:
ledger <- getLedger("ZAR", 67)
