#' Compute Mel-based summaries for all chunks of a word
#'
#' @description This function computes Mel-based summaries for all chunks of a word (or other unit). Uses the outputs of \code{get_mel} and \code{get_chunk_duration}. The length of all summaries is padded with zeros to achieve similar lengths.
#'
#' @param mel_features List of Mel-filterbank energy features. Typically created with \code{get_mel}.
#' @param chunk_duration List of chunk duration. Typically created with \code{get_chunk_duration}.
#' @param n_cols Number of columns that should be sampled. Defaults to \code{20}.
#' @param connected Should the sampled columns be connected, e.g. columns 1-20, or discontinuous? Defaults to \code{TRUE} (connected).
#' @param seed Set seed for reproducibility. Defaults to \code{161211991}.
#' @param method A character string indicating which correlation coefficient (or covariance) is to be computed. One of \code{"spearman"} (default), \code{"kendall"}, or \code{"pearson"}: can be abbreviated.
#' @param progress Show a console progress bar. Defaults to \code{TRUE}.
#'
#' @return A list object.
#'
#' @author Dominic Schmitz
#'
#' @examples
#' \dontrun{band_summaries <- get_band_summaries(mel_features = my_mel_features, chunk_duration = my_chunk_durations)}
#'
#' @import progress
#'
#' @export

get_band_summaries <- function(mel_features, chunk_duration, n_cols = 20, connected = TRUE, seed = 16121991, method = "spearman", progress = TRUE){

  set.seed(seed)

  if(isTRUE(progress)){

    pb <- progress::progress_bar$new(format = "(:spin) [:bar] :percent [Elapsed time: :elapsedfull || Estimated time remaining: :eta]",
                                     total = length(chunk_duration),
                                     complete = "=",   # Completion bar character
                                     incomplete = "-", # Incomplete bar character
                                     current = ">",    # Current bar character
                                     clear = FALSE,    # If TRUE, clears the bar when finish
                                     width = 100)      # Width of the progress bar

  }

  # find largest number of chunks
  chunk_durs <- c()

  for(b in 1:length(chunk_duration)){

    run_dur <- length(chunk_duration[[b]][["boundaries"]])+1

    chunk_durs <- c(chunk_durs, run_dur)

  }

  max_chunks <- max(chunk_durs)

  summaries <- data.frame()

  for(i in 1:length(mel_features)){

    if(isTRUE(progress)){

      pb$tick()

    }

    number_chunks <- (length(chunk_duration[[i]][["boundaries"]])+1)

    chunks <- c()

    for(m in 1:number_chunks){

      if(number_chunks == 1){

        start <- 0
        end <- ncol(mel_features[[i]][["mel"]])

      }
      else if(m == 1){

        start <- 0
        end <- ceiling(chunk_duration[[i]][["boundaries"]][m])

      }else if(m == number_chunks){

        start <- ceiling(chunk_duration[[i]][["boundaries"]][m-1])
        end <- ncol(mel_features[[i]][["mel"]])

      }else{

        start <- ceiling(chunk_duration[[i]][["boundaries"]][m-1])
        end <- ceiling(chunk_duration[[i]][["boundaries"]][m])

      }

      running_chunk <- mel_features[[i]][["mel"]][,start:end]

      if(ncol(running_chunk) < n_cols){

        missing_col <- n_cols - ncol(running_chunk)

        zero_df <- matrix(data = 0, nrow = nrow(running_chunk), ncol = missing_col)

        running_chunk <- cbind(running_chunk, zero_df)

      }

      if(isTRUE(connected)){

        # random range
        random_val1 <- sample(1:(ncol(running_chunk)-n_cols), 1)
        random_val2 <- random_val1 + (n_cols - 1)

        random_range <- random_val1:random_val2

        # sampled data
        sample_data <- data.frame(running_chunk[,random_range])

        # band correlations
        col_correlations <- list()

        for(z in 1:(nrow(sample_data)-1)){

          band_z <- unname(unlist(sample_data[z,]))

          col_run <- c()

          for(y in 1:(nrow(sample_data)-z)){

            band_y <- unname(unlist(sample_data[y,]))

            run_cor <- cor(band_z, band_y, method = method)

            col_run <- c(col_run, run_cor)

          }

          col_correlations[[z]] <- col_run

        }

        # combine to one row
        sample_row  <- c()

        for(g in 1:nrow(sample_data)){

          if(g < nrow(sample_data)){

            run_row <- c(g, sample_data[g,], col_correlations[[g]])

            sample_row <- c(sample_row, run_row)

          }else{

            run_row <- c(g, sample_data[g,])

            sample_row <- c(sample_row, run_row)

          }

        }

        sample_row <- unname(unlist(sample_row))

      }else{

        random_range <- sort(sample(1:ncol(running_chunk), n_cols, replace = FALSE))

        sample_data <- data.frame(running_chunk[,random_range])

        # band correlations
        col_correlations <- list()

        for(z in 1:(nrow(sample_data)-1)){

          band_z <- unname(unlist(sample_data[z,]))

          col_run <- c()

          for(y in 1:(nrow(sample_data)-z)){

            band_y <- unname(unlist(sample_data[y,]))

            run_cor <- cor(band_z, band_y, method = method)

            col_run <- c(col_run, run_cor)

          }

          col_correlations[[z]] <- col_run

        }

        # combine to one row
        sample_row  <- c()

        for(g in 1:nrow(sample_data)){

          if(g < nrow(sample_data)){

            run_row <- c(g, sample_data[g,], col_correlations[[g]])

            sample_row <- c(sample_row, run_row)

          }else{

            run_row <- c(g, sample_data[g,])

            sample_row <- c(sample_row, run_row)

          }

        }

        sample_row <- unname(unlist(sample_row))

      }

      chunks <- c(chunks, sample_row)

    }

    if(((max_chunks * 651) - length(chunks)) != 0){

      padding <- rep(0, (((max_chunks * 651) - length(chunks))))

      chunks <- c(chunks, padding)

    }

    summaries <- rbind(summaries, chunks)

  }

  zero_cols <- which(colSums(summaries != 0) == 0)

  summaries <- summaries[, -zero_cols]

  names(summaries) <- paste0("C", 1:ncol(summaries))

  # get row names
  row_names <- c()

  for(h in 1:length(chunk_duration)){

    run_name <- chunk_duration[[h]][["file"]]

    row_names <- c(row_names, run_name)

  }

  rownames(summaries) <- row_names

  return(summaries)

}
