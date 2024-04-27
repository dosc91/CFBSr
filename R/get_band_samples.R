#' Sample chunks of Mel-filterbank energy features
#'
#' @description This function samples \code{n} columns of Mel-filterbank energy features as range, i.e. the order of columns is retained.
#'
#' @param mel_features List of Mel-filterbank energy features. Typically created with \code{get_mel}.
#' @param n_bands Number of bands that should be sampled. Defaults to \code{20}.
#' @param seed Set seed for reproducibility. Defaults to \code{161211991}.
#'
#' @return A data frame.
#'
#' @author Dominic Schmitz
#'
#' @examples
#' \dontrun{band_samples <- get_band_samples(mel_features = mel_features, n_bands = 20)}
#'
#' @export

get_band_samples <- function(mel_features, n_bands = 20, seed = 16121991){

  set.seed(seed)

  band_samples <- data.frame()

  for(i in 1:length(mel_features)){

    run_data <- mel_features[[i]]$mel

    random_val1 <- sample(1:(ncol(run_data)-n_bands), 1)
    random_val2 <- random_val1 + (n_bands - 1)

    random_range <- random_val1:random_val2

    sample_data <- data.frame(run_data[,random_range])

    file <- mel_features[[i]]$file

    sample_data$file <- file
    sample_data$freq_band <- 1:26

    band_samples <- rbind(band_samples, sample_data)

  }

  names(band_samples) <- c(paste0("chunk", random_val1:random_val2), "file", "band")

  return(band_samples)

}
