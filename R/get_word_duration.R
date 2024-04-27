#' Get word durations, starts, ends
#'
#' @description This function collects the start points, end points, and durations of all words (or whatever else is annotated in your relevant TextGrid tier).
#'
#' @param tg_files A vector of all TextGrid files you want to include. Typically created with \code{get_corpus_files}.
#' @param main_tier The tier with your relevant intervals, e.g. words. Can be given by its name or by its index.
#' @param extra_tier Optional: Include another tier. This tier will be used in unique identifier creation. Can be given by its name or by its index.
#' @param encoding Defaults to \code{UTF-8}.
#'
#' @return A data frame.
#'
#' @author Dominic Schmitz
#'
#' @references Bořil, T., & Skarnitzl, R. (2016). Tools rPraat and mPraat. In P. Sojka, A. Horák, I. Kopeček, & K. Pala (Eds.), Text, Speech, and Dialogue (pp. 367-374). Springer International Publishing.
#'
#' @examples
#' \dontrun{corpus_files <- get_corpus_files(path = "data", "wav")
#'
#' wd_df <- get_word_duration(tg_files = corpus_files[[2]], main_tier = 1)
#' wd_df <- get_word_duration(tg_files = corpus_files[[2]], main_tier = 1, extra_tier = 2)
#'
#' wd_df <- get_word_duration(tg_files = corpus_files[[2]], main_tier = "word")
#' wd_df <- get_word_duration(tg_files = corpus_files[[2]], main_tier = "word", extra_tier = "ID")}
#'
#' @import rPraat
#' @export

get_word_duration <- function(tg_files, main_tier, extra_tier = NULL, encoding = "UTF-8"){

  if(is.character(main_tier) & is.numeric(extra_tier) | is.numeric(main_tier) & is.character(extra_tier)){

    stop("Please specify both main_tier and extra_tier as either character or numeric value. Please resolve this issue.")

  }

  wd_df <- data.frame()

  if(is.character(main_tier)){

    for(i in 1:length(tg_files)){

      tg_run <- tg.read(tg_files[i], encoding = encoding)

      main_id <- which(names(tg_run) == main_tier)

      non_empty <- which(tg_run[[main_id]]$label != "")

      if(!is.null(extra_tier)){

        extra_id <- which(names(tg_run) == extra_tier)

        extra_name <- tg.getTierName(tg_run, extra_id)

        non_empty_extra <- which(tg_run[[extra_id]]$label != "")

        if(length(non_empty) != length(non_empty_extra)){

          stop("Number of non-empty intervals on main_tier and extra_tier do not match. Please resolve this issue.")

        }

      }

      tg_df <- data.frame()

      for(m in 1:length(non_empty)){

        dur_run <- tg.getIntervalDuration(tg_run, main_id, index = non_empty[m])
        sta_run <- tg.getIntervalStartTime(tg_run, main_id, index = non_empty[m])
        end_run <- tg.getIntervalEndTime(tg_run, main_id, index = non_empty[m])

        tg_df[m,1] <- tg.getLabel(tg_run, main_id, index = non_empty[m])
        tg_df[m,2] <- dur_run
        tg_df[m,3] <- sta_run
        tg_df[m,4] <- end_run
        tg_df[m,5] <- tg_files[i]

        if(!is.null(extra_tier)){

          tg_df[m,6] <- tg.getLabel(tg_run, extra_id, index = non_empty_extra[m])

        }

      }

      wd_df <- rbind(wd_df, tg_df)

    }

    names(wd_df) <- c("word", "duration", "start", "end", "file")

    if(!is.null(extra_tier)){

      names(wd_df)[6] <- extra_name

    }

  }else if(is.numeric(main_tier)){

    for(i in 1:length(tg_files)){

      tg_run <- tg.read(tg_files[i], encoding = encoding)

      main_id <- main_tier

      non_empty <- which(tg_run[[main_id]]$label != "")

      if(!is.null(extra_tier)){

        extra_id <- extra_tier

        extra_name <- tg.getTierName(tg_run, extra_id)

        non_empty_extra <- which(tg_run[[extra_id]]$label != "")

        if(length(non_empty) != length(non_empty_extra)){

          stop("Number of non-empty intervals on main_tier and extra_tier do not match. Please resolve this issue.")

        }

      }

      tg_df <- data.frame()

      for(m in 1:length(non_empty)){

        dur_run <- tg.getIntervalDuration(tg_run, main_id, index = non_empty[m])
        sta_run <- tg.getIntervalStartTime(tg_run, main_id, index = non_empty[m])
        end_run <- tg.getIntervalEndTime(tg_run, main_id, index = non_empty[m])

        tg_df[m,1] <- tg.getLabel(tg_run, main_id, index = non_empty[m])
        tg_df[m,2] <- dur_run
        tg_df[m,3] <- sta_run
        tg_df[m,4] <- end_run
        tg_df[m,5] <- tg_files[i]

        if(!is.null(extra_tier)){

          tg_df[m,6] <- tg.getLabel(tg_run, extra_id, index = non_empty_extra[m])

        }

      }

      wd_df <- rbind(wd_df, tg_df)

    }

    names(wd_df) <- c("word", "duration", "start", "end", "file")

    if(!is.null(extra_tier)){

      names(wd_df)[6] <- extra_name

    }

  }

  return(wd_df)

}
