% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/decaf_client.R
\name{build_http_header_authorization}
\alias{build_http_header_authorization}
\title{Builds and returns the "Authorization" HTTP header for the HTTP calls
originating from this library.}
\usage{
build_http_header_authorization(credentials)
}
\arguments{
\item{credentials}{An instance of 'decaf.client.credentials' S3 class.}
}
\value{
A named-list for \code{Authorization} key-value pair.
}
\description{
Builds and returns the "Authorization" HTTP header for the HTTP calls
originating from this library.
}
