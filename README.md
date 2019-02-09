# spotify_trackeR

spotify_trackeR helps to track your spotify song history. It should be run on a server by using a cronjob every e.g. 1 hour. As the spotify API returns the latest 50 tracks only, spotify_trackeR will pull your latest 50 tracks every time and will save it as RDS and csv file. Each time new songs are added to the already stored history.

spotify_trackeR is mainly based on [spotifyr](https://www.rcharlie.com/spotifyr/).

You need a Spotify Dev account to access the API (see link above).
