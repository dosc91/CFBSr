#' Collect corpus sound files and TextGrids
#'
#' @description This function creates lists of sound and TextGrid files. This is the initial step of the CFBS analysis.
#'
#' @param path The path to the directory containing sound and TextGrid files.
#' @param sound_types The types of sound files that should be listed. Defaults to /code{"wav}.
#'
#' @return A list object.
#'
#' @author Dominic Schmitz
#'
#' @examples
#' corpus_files <- get_corpus_files(path = "data", "wav")
#'
#' @export

get_corpus_files <- function(path = NULL, sound_types = "wav"){

  if(is.null(path)){

    path = getwd()

  }

  sound_files <- list.files(path = path, pattern = paste0("*.(", paste(sound_types, collapse = "|"), ")$"), ignore.case = TRUE, full = T)
  tg_files <- list.files(path = path, pattern = "*TextGrid$", ignore.case = TRUE, full = T)

  corpus_files <- list()
  corpus_files[[1]] <- sound_files
  corpus_files[[2]] <- tg_files

  return(corpus_files)

}
