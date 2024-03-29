% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/backup.R
\name{list_cran_packages}
\alias{list_cran_packages}
\title{Filter CRAN packages}
\usage{
list_cran_packages(packages)
}
\arguments{
\item{packages}{a data frame of package names and versions (i.e. The output of \code{list_packages()})}
}
\value{
a vector of package names
}
\description{
Takes a data frame of package names and versions (i.e. The output of \code{list_packages()}), and return only the names of packages that are available on CRAN.
}
