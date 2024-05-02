#' Cut sound files
#'
#' @description This function cuts sound files by non-empty intervals on a specified tier. This tier commonly corresponds to the \code{main_tier} specified in \code{get_word_duration}.
#'
#' @param sound_files A vector of all wav files you want to include.
#' @param word_durations The durations of words or other relevant intervals. Typically identified using \code{get_word_duration}.
#' @param extra_tier Optional: Include another tier. This tier will be used in unique identifier creation. Can be given by its name or by its index.
#' @param directory Specify the directory in which the new wav files should be saved.
#' @param fileType Type of audio file: \code{"wav"}, \code{"mp3"}, or \code{"auto"}.
#' @param from Where to start reading in units.
#' @param to Where to stop reading.
#' @param units Units of \code{from} and \code{to} arguments.
#'
#' @return A list object.
#'
#' @author Dominic Schmitz
#'
#' @references Bořil, T., & Skarnitzl, R. (2016). Tools rPraat and mPraat. In P. Sojka, A. Horák, I. Kopeček, & K. Pala (Eds.), Text, Speech, and Dialogue (pp. 367-374). Springer International Publishing.
#'
#' @examples
#' \dontrun{get_word_sound_files(sound_files = corpus_files[[1]], word_durations = wd_df, extra_tier = "ID", directory = "C:/Users/Project/chopped")}
#'
#' @import rPraat
#' @export

get_word_sound_files <- function(sound_files, word_durations, extra_tier = NULL, directory, fileType = "auto", from = 1, to = Inf, units = "samples"){

  for(i in 1:nrow(word_durations)){

    sound_file <- gsub("\\.TextGrid", "\\.wav", word_durations$file[i])

    sound_run <- rPraat::snd.read(sound_file, fileType = fileType, from = from, to = to, units = units)

    sound_cut <- rPraat::snd.cut(sound_run, Start = word_durations$start[i], End = word_durations$end[i], units = "seconds")

    if(!is.null(extra_tier)){

      extra_index <- which(names(word_durations) == extra_tier)

      chop_file <- gsub(".*/", "", word_durations$file[i])
      chop_file <- gsub("\\.TextGrid", "", chop_file)
      chop_file <- paste(chop_file, word_durations[i,extra_index], sep = "_")
      chop_file <- paste(chop_file, "wav", sep = ".")

    }else{

      chop_file <- gsub(".*/", "", word_durations$file[i])
      chop_file <- gsub("\\.TextGrid", "", chop_file)
      chop_file <- paste(chop_file, i, sep = "_")
      chop_file <- paste(chop_file, "wav", sep = ".")

    }

    chop_file <- paste0(directory, "/", chop_file)

    rPraat::snd.write(sound_cut, chop_file)

  }

}
