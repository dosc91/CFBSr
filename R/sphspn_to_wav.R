#' Convert SPH & SPN files to wav files
#'
#' @description Using a bash script, this function converts SPH and SPN sound files to wav files. Run this first if your sound files are not wav files.
#' Note: Currently, this only works on Windows. Additionally, \code{SoX - Sound eXchange} must be installed before running this function, see https://sourceforge.net/projects/sox/.
#'
#' @param path The path to the directory containing SPH and SPN sound files.
#'
#' @return Nothing.
#'
#' @author Dominic Schmitz
#'
#' @examples
#' \dontrun{sphspn_to_wav(path = "C:/Users/Dominic/Dropbox/HHU_2373/Compounds/CFBSFr/data")}
#'
#' @export

sphspn_to_wav <- function(path){

  batch_content <- '
                   cd %~dp0
                   for %%a in (*.spn) do sox "%%~a" "%%~na.wav"
                   for %%a in (*.sph) do sox "%%~a" "%%~na.wav"
                   pause
                   '

  batch_file_path <- paste0(path, "/sphspn_to_wav.bat")

  writeLines(batch_content, con = batch_file_path)

  cat("Batch file created at:", batch_file_path, "\n")

  system(batch_file_path, wait = TRUE, show.output.on.console =FALSE)

  cat("Files converted at:", path)

}
