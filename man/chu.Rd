% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/chu.R
\name{chu}
\alias{chu}
\title{Calculate daily Ontario crop heat units for a given canadaHCD station}
\source{
\insertRef{omafra_staff_field_2011}{canadaHCDx}
}
\usage{
chu(datain, report = c("chu", "gdd"), tbase = 0)
}
\arguments{
\item{datain}{A \code{tibble} containing the data to process}

\item{report}{character; a vector of units to report (\code{"chu"} and/or \code{"gdd"})}

\item{tbase}{numeric; a base temperature for GDD calculation}
}
\description{
Adds a column containing CHUs to the end of a \code{\link{tibble}} generated by \code{\link{hcd_daily}}.
}
\examples{

# Calulcate daily CHU at New Glasgow, Ontario
ng <- hcd_daily(4656, 1981:2010)
chu(ng)
chu(ng, report = "gdd", tbase = 10)

}
\author{
Conor I. Anderson
}
