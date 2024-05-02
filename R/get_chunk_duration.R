#' Compute chunk boundaries based on the Hilbert amplitude envelope
#'
#' @description This function computes chunk boundaries from audio signals based on the Hilbert amplitude envelope.
#'
#' @param chopped_dir Directory of the individual sound files. Typically created with \code{get_word_sound_files}.
#' @param window Size of the rolling window to apply the \code{fun}ction to.
#' @param smooth The parameter controlling the bandwidth of the kernel. Defaults to \code{800}.
#' @param kernel The type of kernel. Defaults to \code{"daniell"}.
#' @param plot Whether a plot should be created for each Hilbert envelope. Defaults to \code{FALSE}. Note that plotting takes a substantial amount of time.
#' @param fun Function to identify chunk boundaries by. Defaults to \code{"min"} following Arnold et al. (2017). Alternatively takes \code{max}, following Shafaei-Bajestan et al. (2023).
#' @param progress Show a console progress bar. Defaults to \code{TRUE}.
#'
#' @return A list object.
#'
#' @author Dominic Schmitz
#'
#' @references Arnold, D. (2018). AcousticNDLCodeR: Coding Sound Files for Use with NDL. R package version 1.0.2. Retrieved from https://CRAN.R-project.org/package=AcousticNDLCodeR
#' @references Arnold, D., Tomaschek, F., Sering, K., Lopez, F., & Baayen, R. H. (2017). Words from spontaneous conversational speech can be recognized with human-like accuracy by an error-driven learning algorithm that discriminates between meanings straight from smart acoustic features, bypassing the phoneme as recognition unit. PLOS ONE, 12(4), e0174623. https://doi.org/10.1371/journal.pone.0174623
#' @references Ligges, U., Krey, S., Mersmann, O., & Schnackenberg, S. (2023). tuneR: Analysis of Music and Speech. Retrieved from https://CRAN.R-project.org/package=tuneR
#' @references Shafaei-Bajestan, E., Moradipour-Tari, M., Uhrig, P., & Baayen, R. H. (2023). LDL-AURIS: a computational model, grounded in error-driven learning, for the comprehension of single spoken words. Language, Cognition and Neuroscience, 38(4), 509–536. https://doi.org/10.1080/23273798.2021.1954207
#' @references Sueur, J., Aubin, T., & Simonis, C. (2008). Seewave: a free modular tool for sound analysis and synthesis. Bioacoustics, 18(3), 213-226.
#' @references Zeileis, A., & Grothendieck, G. (2005). zoo: S3 Infrastructure for Regular and Irregular Time Series. Journal of Statistical Software, 14(6), 1-27. https://doi.org/10.18637/jss.v014.i06
#'
#' @examples
#' \dontrun{chunk_durations <- get_chunk_duration(chopped_dir = "C:/Users/Project/chopped", fun = "min")}
#'
#' @import tuneR
#' @import seewave
#' @import zoo
#' @import progress
#'
#' @export

get_chunk_duration <- function(chopped_dir, window = 1000, smooth = 800, kernel = "daniell", plot = FALSE, fun = "min", progress = TRUE){

  chopped_files <- list.files(chopped_dir, pattern = "*wav$", ignore.case = TRUE, full = T)

  if(isTRUE(progress)){

    pb <- progress::progress_bar$new(format = "(:spin) [:bar] :percent [Elapsed time: :elapsedfull || Estimated time remaining: :eta]",
                                     total = length(chopped_files),
                                     complete = "=",   # Completion bar character
                                     incomplete = "-", # Incomplete bar character
                                     current = ">",    # Current bar character
                                     clear = FALSE,    # If TRUE, clears the bar when finish
                                     width = 100)      # Width of the progress bar

  }

  chunks <- list()

  for(i in 1:length(chopped_files)){

    if(isTRUE(progress)){

      pb$tick()

    }

    sound <- tuneR::readWave(chopped_files[i])

    if(sound@samp.rate != 16000){

      sound_resamp <- seewave::resamp(sound, sound@samp.rate, 16000)

    }else{

      sound_resamp <- sound

    }

    if (length(sound_resamp) > (window + (2 * smooth))) {

      envelope = seewave::env(sound_resamp, f = 16000, ksmooth = kernel(kernel, smooth), plot = plot)

      envelope_zoo = zoo::as.zoo(envelope)

      if(fun == "min"){

        min_fun = zoo::rollapply(envelope_zoo, window, function(x) which.min(x) == 500)

        indices = zoo::index(min_fun[zoo::coredata(min_fun)])

      }else if(fun == "max"){

        max_fun = zoo::rollapply(envelope_zoo, window, function(x) which.max(x) == 500)

        indices = zoo::index(max_fun[zoo::coredata(max_fun)])

      }

      indices = ceiling(indices * (length(sound_resamp)/length(envelope)))

    }

    chunks[[i]] <- list()
    chunks[[i]]$file <- gsub(".*/", "", chopped_files[i])
    chunks[[i]]$boundaries <- indices / 160

  }

  return(chunks)

}
