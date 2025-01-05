#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/icons.sh"

RUNNING=$(osascript -e 'if application "Spotify" is running then return 0')
if [ "$RUNNING" == "" ]; then
  RUNNING=1
fi

if [ $RUNNING -eq 0 ] then 
  CURRENT_SONG=$(osascript -e 'if application "Spotify" is running then tell application "Spotify" to return name of current track')
  CURRENT_ARTIST=$(osascript -e 'if application "Spotify" is running then tell application "Spotify" to return artist of current track')
  CURRENT_ALBUM=$(osascript -e 'if application "Spotify" is running then tell application "Spotify" to return album of current track')
  CURRENT_COVER=$(osascript -e 'if application "Spotify" is running then tell application "Spotify" to return artwork url of current track')
  WIDTH=$(((${#CURRENT_SONG} * 10) + 10))
else 
  CURRENT_SONG=""
  CURRENT_ARTIST=""
  CURRENT_ALBUM=""
  CURRENT_COVER=""
  WIDTH=0
fi

curl -s --max-time 20 "$CURRENT_COVER" -o /tmp/cover.jpg

detail_on() {
  sketchybar --animate tanh 30 --set spotify_label slider.width=$WIDTH
}

detail_off() {
  sketchybar --animate tanh 30 --set spotify_label slider.width=0
}

spotify_cover=(
  label.drawing=off
  icon.drawing=off
  padding_left=12
  padding_right=10
  background.image.scale=0.13
  background.image.drawing=on
  background.drawing=on
  background.image="/tmp/cover.jpg"
)

sketchybar --add item spotify.cover popup.spotify \
  --set spotify.cover "${spotify_cover[@]}"

spotify_title=(
  label.font="SF Pro:Bold:15.0"
  label="$CURRENT_SONG"
  icon.drawing=off
  padding_left=0
  padding_right=0
  width=0
  label.font="SF Pro:Bold:15.0"
  y_offset=30
)

sketchybar --add item spotify.title popup.spotify \
  --set spotify.title "${spotify_title[@]}"

spotify_artist=(
  icon.drawing=off
  y_offset=7
  padding_left=0
  padding_right=0
  width=0
  label.font="SF Pro:Regular:14.0"
  label="$CURRENT_ARTIST"
)

sketchybar --add item spotify.artist popup.spotify \
  --set spotify.artist "${spotify_artist[@]}"

spotify_album=(
  icon.drawing=off
  padding_left=0
  padding_right=0
  y_offset=-25
  width=0
  label.font="SF Pro:Bold:11.0"
  label="$CURRENT_ALBUM"
  background.padding_right=235
)

sketchybar --add item spotify.album popup.spotify \
  --set spotify.album "${spotify_album[@]}"

sketchybar --set spotify_label label="$CURRENT_SONG"
