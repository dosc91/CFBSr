% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_band_samples.R
\name{get_band_samples}
\alias{get_band_samples}
\title{Note: This function is deprecated}
\usage{
get_band_samples(mel_features, n_cols = 20, connected = TRUE, seed = 16121991)
}
\arguments{
\item{mel_features}{List of Mel-filterbank energy features. Typically created with \code{get_mel}.}

\item{n_cols}{Number of columns that should be sampled. Defaults to \code{20}.}

\item{connected}{Should the sampled columns be connected, e.g. columns 1-20, or discontinuous? Defaults to \code{TRUE} (connected).}

\item{seed}{Set seed for reproducibility. Defaults to \code{161211991}.}
}
\value{
A data frame.
}
\description{
Note: This function is deprecated. This function samples \code{n} columns of Mel-filterbank energy features as range, i.e. the order of columns is retained. Also provides some summary measures: first and last value, min and max value, and median of each column. Note: Currently, this function does not take into account chunk boundaries.
}
\examples{
\dontrun{band_samples <- get_band_samples(mel_features = mel_features, n_cols = 20)}

}
\author{
Dominic Schmitz
}
