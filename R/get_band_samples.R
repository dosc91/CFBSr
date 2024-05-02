#' Sample chunks of Mel-filterbank energy features
#'
#' @description This function samples \code{n} columns of Mel-filterbank energy features as range, i.e. the order of columns is retained. Also provides some summary measures: first and last value, min and max value, and median of each column. Note: Currently, this function does not take into account chunk boundaries.
#'
#' @param mel_features List of Mel-filterbank energy features. Typically created with \code{get_mel}.
#' @param n_cols Number of columns that should be sampled. Defaults to \code{20}.
#' @param connected Should the sampled columns be connected, e.g. columns 1-20, or discontinuous? Defaults to \code{TRUE} (connected).
#' @param seed Set seed for reproducibility. Defaults to \code{161211991}.
#'
#' @return A data frame.
#'
#' @author Dominic Schmitz
#'
#' @examples
#' \dontrun{band_samples <- get_band_samples(mel_features = mel_features, n_cols = 20)}
#'
#' @export

get_band_samples <- function(mel_features, n_cols = 20, connected = TRUE, seed = 16121991){

  set.seed(seed)

  band_samples <- list()

  for(i in 1:length(mel_features)){

    run_data <- mel_features[[i]]$mel

    # run_samples <- data.frame()

    if(isTRUE(connected)){

      random_val1 <- sample(1:(ncol(run_data)-n_cols), 1)
      random_val2 <- random_val1 + (n_cols - 1)

      random_range <- random_val1:random_val2

      sample_data <- data.frame(run_data[,random_range])

      file <- mel_features[[i]]$file

      sample_data$file <- file
      sample_data$freq_band <- 1:nrow(sample_data)

      names(sample_data) <- c(paste0("column", random_val1:random_val2), "file", "band")

      band_summary <- data.frame(column = random_val1:random_val2,
                                 first_value = unlist(sample_data[1,1:n_cols]),
                                 median_value = c(apply(sample_data[,1:n_cols], 2, median)),
                                 min_value = c(apply(sample_data[,1:n_cols], 2, min)),
                                 max_value = c(apply(sample_data[,1:n_cols], 2, max)),
                                 last_value = unlist(sample_data[nrow(sample_data),1:n_cols]))

      band_samples[[i]] <- list()
      band_samples[[i]]$sample <-  sample_data
      band_samples[[i]]$summary <-  band_summary

    }else{

      random_range <- sort(sample(1:ncol(run_data), n_cols, replace = FALSE))

      sample_data <- data.frame(run_data[,random_range])

      file <- mel_features[[i]]$file

      sample_data$file <- file
      sample_data$freq_band <- 1:nrow(sample_data)

      names(sample_data) <- c(paste0("column", random_range), "file", "band")

      band_summary <- data.frame(column = random_range,
                                 first_value = unlist(sample_data[1,1:n_cols]),
                                 median_value = c(apply(sample_data[,1:n_cols], 2, median)),
                                 min_value = c(apply(sample_data[,1:n_cols], 2, min)),
                                 max_value = c(apply(sample_data[,1:n_cols], 2, max)),
                                 last_value = unlist(sample_data[nrow(sample_data),1:n_cols]))

      run_list <- list()
      run_list[[i]]$sample <-  sample_data
      run_list[[i]]$summary <-  band_summary

    }

  }

  return(band_samples)

}
