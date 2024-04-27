#' Compute Mel-filterbank energy features from audio
#'
#' @description This function computes Mel-filterbank energy features from audio signals.
#'
#' @param chopped_dir Directory of the individual sound files. Typically created with \code{get_word_sound_files}.
#' @param winlen The length of the analysis window in seconds. Default is \code{0.025}.
#' @param winstep The step between successive windows in seconds. Default is \code{0.01}.
#' @param nfft The FFT size. Default is \code{512}.
#' @param nfilt The number of filters in the filterbank. Default is \code{26}.
#' @param lowfreq Lowest band edge of Mel filters. In Hz, default is \code{0}.
#' @param highfreq Highest band edge of Mel filters. In Hz, default is \code{samplerate/2}.
#'
#' @return A list object.
#'
#' @author Dominic Schmitz
#'
#' @references Uwe Ligges, Sebastian Krey, Olaf Mersmann, and Sarah Schnackenberg (2023). tuneR: Analysis of Music and Speech. URL: https://CRAN.R-project.org/package=tuneR
#' @references James Lyons, Darren Yow-Bang Wang, Gianluca, Hanan Shteingart, Erik Mavrinac, Yash Gaurkar, Watcharapol Watcharawisetkul, Sam Birch, Lu Zhihe, Josef Hölzl, Janis Lesinskis, Henrik Almér, Chris Lord, & Adam Stark. (2020). jameslyons/python_speech_features: release v0.6.1 (0.6.1). Zenodo. https://doi.org/10.5281/zenodo.3607820
#'
#' @examples
#' \dontrun{mel_features <- get_mel(chopped_dir = "/chopped")}
#'
#' @import tuneR
#' @export

get_mel <- function(chopped_dir, winlen = 0.025, winstep = 0.01, nfft = 512, nfilt = 26, lowfreq = 0, highfreq = NULL){

  chopped_files <- list.files(path = paste0(getwd(), chopped_dir), pattern = "*wav$", ignore.case = TRUE, full = T)

  mel_freq <- list()

  for(i in 1:length(chopped_files)){

    wav_run = tuneR::readWave(chopped_files[i])

    if(is.null(highfreq)){

      highfreq <- wav_run@samp.rate / 2

    }

    signal = preemphasis(wav_run@left)

    frames = framesig(signal, winlen * wav_run@samp.rate, winstep*wav_run@samp.rate)

    if (ncol(frames) < nfft) {
      frames <- cbind(frames, matrix(0, nrow = nrow(frames), ncol = nfft - ncol(frames)))
    }

    pspec <- apply(frames, 1, function(frame) {
      tuneR::powspec(frame, wav_run@samp.rate, winlen, winstep)
    })

    spec = log(tuneR::audspec(pspec, sr = wav_run@samp.rate, nfilts = nfilt, fbtype = "mel", minfreq = lowfreq, maxfreq = highfreq)$aspec + 1)

    mel_freq[[i]] <- list()
    mel_freq[[i]]$file <- gsub(".*/", "", chopped_files[i])
    mel_freq[[i]]$mel <- spec

  }

  return(mel_freq)

}

preemphasis <- function(signal, coeff = 0.95) {
  filtered_signal <- c(signal[1], signal[-1] - coeff * signal[-length(signal)])
  return(filtered_signal)
}

framesig <- function(sig, frame_len, frame_step, winfunc = function(x) rep(1, x)) {
  slen <- length(sig)
  frame_len <- as.integer(round(frame_len))
  frame_step <- as.integer(round(frame_step))
  if (slen <= frame_len) {
    numframes <- 1
  } else {
    numframes <- 1 + as.integer(ceiling((1.0 * slen - frame_len) / frame_step))
  }

  padlen <- as.integer((numframes - 1) * frame_step + frame_len)
  zeros <- rep(0, padlen - slen)
  padsignal <- c(sig, zeros)

  indices <- matrix(rep(0, numframes * frame_len), nrow = numframes, ncol = frame_len)
  for (i in 1:numframes) {
    indices[i,] <- seq(0, frame_len - 1) + (i - 1) * frame_step + 1
  }

  frames <- padsignal[indices]
  win <- matrix(rep(winfunc(frame_len), numframes), nrow = numframes, ncol = frame_len, byrow = TRUE)
  return(frames * win)
}
