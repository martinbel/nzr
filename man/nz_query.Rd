% Generated by roxygen2 (4.0.0.99): do not edit by hand
\name{nz_query}
\alias{nz_query}
\title{nz_query}
\usage{
nz_query(query = NULL)
}
\arguments{
\item{q}{query to be exported}

\item{fetchSize}{}

\item{file}{}

\item{requires}{a nzcon Java Connection}
}
\description{
Sends a query to the database and gets the result.
Solves the white space issues RJDBC has by adding a trim() call to each field.
}

