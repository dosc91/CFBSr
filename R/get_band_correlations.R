#' Note: This function is deprecated
#'
#' @description Note: This function is deprecated. This function computes correlations between columns of Mel-filterbank energy features. Note: Currently, this function does not take into account chunk boundaries.
#'
#' @param band_samples Samples of chunks of Mel-filterbank energy features. Typically created with \code{get_band_samples}.
#' @param n_cols Number of columns that should be sampled. Defaults to \code{20}.
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

get_band_correlations <- function(band_samples, n_cols = 20, method = "spearman"){

  correlations <- data.frame()

  for(i in 1:length(band_samples)){

    run_subset <- band_samples[[i]][["sample"]]

    col_correlations <- data.frame()

    for(m in 1:(n_cols-1)){

      run_cor <- cor(run_subset[,m], run_subset[,m+1], method = method)

      col_correlations[1,m] <- run_cor

    }

    col_correlations[1,m+1] <- run_subset$file[1]

    correlations <- rbind(correlations, col_correlations)

  }

  names(correlations) <- c(paste0("c", 1:(n_cols-1)), "file")

  return(correlations)

}
