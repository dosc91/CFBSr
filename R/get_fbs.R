#' Compute Mel-filterbank energy features from audio
#'
#' @description This function computes Mel-filterbank energy features from audio signals. Clone of \code{get_mel}.
#'
#' @param chopped_dir Directory of the individual sound files. Typically created with \code{get_word_sound_files}.
#' @param sample_rate Sample rate of your wav files. Default is \code{16000}.
#' @param winlen The length of the analysis window in seconds. Default is \code{0.005}.
#' @param steptime The step between successive windows in seconds. Default is \code{0.01}.
#' @param fft The FFT size. Default is \code{512}.
#' @param nfilt The number of filters in the filterbank. Default is \code{21}.
#' @param dither Add dither to MEL features. Defaults to \code{FALSE}.
#'
#' @return A list object.
#'
#' @author Dominic Schmitz
#'
#' @references Ligges, U., Krey, S., Mersmann, O., & Schnackenberg, S. (2023). tuneR: Analysis of Music and Speech. Retrieved from https://CRAN.R-project.org/package=tuneR
#' @references Signal developers. (2023). signal: Signal processing. Retrieved from https://r-forge.r-project.org/projects/signal/
#'
#' @examples
#' \dontrun{fbs_data <- get_fbs(chopped_dir = "/chopped")}
#'
#' @import tuneR
#' @import signal
#'
#' @export

get_fbs <- function(chopped_dir, sample_rate = 16000, winlen = 0.005, steptime = 0.01, fft = 512, nfilt = 21, dither = FALSE){

  chopped_files <- list.files(chopped_dir, pattern = "*wav$", ignore.case = TRUE, full = T)

  mel_freq <- list()

  for(i in 1:length(chopped_files)){

    sound <- tuneR::readWave(chopped_files[i])

    winpts <- round(winlen * sample_rate)

    steppts <- round(steptime * sample_rate)

    window <- signal::hamming(winpts)

    noverlap <- winpts - steppts

    ps <- abs(signal::specgram(sound@left, n = fft, Fs = sample_rate, window = window, overlap = noverlap)$S)^2

    if (isTRUE(dither)) {

      ps <- ps + winpts

    }

    ##
    spec = log(tuneR::audspec(ps, sr = sample_rate, fbtype = "mel", nfilts = nfilt)$aspec + 1)

    mel_freq[[i]] <- list()
    mel_freq[[i]]$file <- gsub(".*/", "", chopped_files[i])
    mel_freq[[i]]$mel <- spec

  }

  return(mel_freq)

}
