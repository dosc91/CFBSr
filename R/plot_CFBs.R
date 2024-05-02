#' Compute correlations between columns of Mel-filterbank energy features
#'
#' @description This function computes correlations between columns of Mel-filterbank energy features. Note: Currently, this function does not take into account chunk boundaries.
#'
#' @param fbs FBS list. Typically created with either \code{get_fbs} or \code{get_mel}.
#' @param chunk_durations Chunk duration list. Typically created with either \code{get_chunk_duration}.
#' @param file Name of the file you want to plot.
#' @param tile_colour Line colour of the tiles. Defaults to \code{"black"}.
#' @param boundary_colour Line colour of the boundary lines. Defaults to \code{"red"}.
#' @param linewidth Line width of the boundary lines. Defaults to \code{2}.
#'
#' @return A data frame.
#'
#' @author Dominic Schmitz
#'
#' @references Wickham, H. (2016). ggplot2: Elegant Graphics for Data Analysis. Springer-Verlag New York. ISBN 978-3-319-24277-4. Retrieved from https://ggplot2.tidyverse.org
#' @references Wickham, H. (2007). Reshaping Data with the {reshape} Package. Journal of Statistical Software, 21(12), 1-20. Retrieved from http://www.jstatsoft.org/v21/i12/
#'
#' @examples
#' \dontrun{
#' plot_CFBs(fbs = fbs, chunk_durations = chunk_durations, file = "example.wav")
#' }
#'
#' @import ggplot2
#' @import reshape2
#'
#' @export

plot_CFBs <- function(fbs, chunk_durations, file, tile_colour = "black", boundary_colour = "red", linewidth = 2){

  matching_index <- NULL
  for (i in seq_along(fbs)) {
    if ("file" %in% names(fbs[[i]]) && fbs[[i]]$file == file) {
      matching_index <- i
      break
    }
  }

  fbs_data <- fbs[[matching_index]]$mel
  boundary_data <- chunk_durations[[matching_index]]$boundaries

  long_fbs_data <- reshape2::melt(fbs_data)
  names(long_fbs_data) <- c("freq_band", "ind", "value")

  boundary_data_df <- data.frame(xintercept = boundary_data)

  p <- ggplot() +
    geom_tile(data = long_fbs_data, aes(x = ind, y = freq_band, group = freq_band, fill = value), color = tile_colour) +
    geom_vline(data = boundary_data_df, aes(xintercept = xintercept), color = boundary_colour, linewidth = linewidth) +
    theme_bw() +
    scale_x_discrete(expand = c(0,0)) +
    scale_y_continuous(expand = c(0,0)) +
    scale_fill_viridis_c(direction = 1) +
    xlab("time") +
    ylab("frequency band")

  return(p)

}
