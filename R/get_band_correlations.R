#' Compute correlations between chunks of Mel-filterbank energy features
#'
#' @description This function creates lists of sound and TextGrid files. This is the initial step of the CFBSF analysis.
#'
#' @param band_samples Samples of chunks of Mel-filterbank energy features. Typically created with \code{get_band_samples}.
#' @param n_bands Number of bands that should be sampled. Defaults to \code{20}.
#' @param method A character string indicating which correlation coefficient (or covariance) is to be computed. One of \code{"spearman"} (default), \code{"kendall"}, or \code{"pearson"}: can be abbreviated.
#'
#' @return A data frame.
#'
#' @author Dominic Schmitz
#'
#' @examples
#' \dontrun{
#' band_correlations <- get_band_correlations(band_samples)
#' }
#'
#' @export

get_band_correlations <- function(band_samples, n_bands = 20, method = "spearman"){

  band_correlations <- data.frame()

  for(i in 1:length(unique(as.factor(band_samples$file)))){

    run_subset <- subset(band_samples, file == unique(as.factor(band_samples$file))[i])

    run_correlations <- data.frame()

    for(m in 1:(n_bands-1)){

      run_cor <- cor(run_subset[,m], run_subset[,m+1], method = method)

      run_correlations[1,m] <- run_cor

    }

    band_correlations <- rbind(band_correlations, run_correlations)

  }

  band_correlations$files <- unique(as.factor(band_samples$file))

  names(band_correlations)[1:n_bands] <- c(paste(1:(n_bands-1), 2:n_bands, sep = "vs"), "file")

  return(band_correlations)

}
