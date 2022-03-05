# ----------------------------- #
# Author: Lukas Richter
# Date: 2019-02-09
# ----------------------------- #
# get spotify history (last 50) and add to data

# Basic functions and packages
suppressPackageStartupMessages(suppressWarnings({
  library(spotifyr)
  library(dplyr)
  library(here)
  library(readr)
  library(httpuv)
  library(lubridate)
}))

path <- paste0(here(), "/") # "D:/Rstuff/spotify_stuff/"

# set spotify auth variables
# spoty_auth.R sets the following two variables:
# Sys.setenv(SPOTIFY_CLIENT_ID = 'xxx')
# Sys.setenv(SPOTIFY_CLIENT_SECRET = 'yyy')
source(paste0(path, "spoty_auth.R"))
access_token <- get_spotify_access_token()

# load full history
# my_alltime <- readr::read_csv2(paste0(path, "data/spotify_alltime.csv"))
rds_file <- paste0(path, "data/spotify_alltime.RDS")
if (file.exists(rds_file)) {
  my_alltime <- readRDS(file = rds_file)
}

# get last 50 songs
my_recent_pl <- spotifyr::get_my_recently_played(limit = 50)

my_recent_pl$artist_name <- sapply(1:nrow(my_recent_pl), function(x) paste0(my_recent_pl$track.artists[[x]]$name, collapse = ", "))

my_recent_pl <- my_recent_pl %>% 
  dplyr::mutate(
    played_at_utc = lubridate::as_datetime(played_at)
  ) %>% 
  dplyr::rename(
    track_name = track.name,
    artist_name = artist_name,
    album_name = track.album.name,
    track_uri = track.uri
  ) %>% 
  dplyr::select(track_name, 
                artist_name, 
                album_name, 
                played_at_utc, 
                track_uri) 

rds_file <- paste0(path, "data/spotify_alltime.RDS")
if (file.exists(rds_file)) {
  my_alltime <- dplyr::full_join(my_alltime, my_recent_pl,
                                 by = names(my_alltime)) 
} else {
  my_alltime <- my_recent_pl
}

my_alltime <- my_alltime %>% 
  dplyr::arrange(dplyr::desc(played_at_utc))

saveRDS(my_alltime, file = paste0(path, "data/spotify_alltime.RDS"))

readr::write_delim(my_alltime,
                   path = paste0(path, "data/spotify_alltime.csv"),
                   delim = ";")

