#!/bin/bash

#-----------------------------------------------------------#
# Date: November 04, 2020
# Name: Gabriel F. Vilar (CoGUMm)
# Email: gabriel[at]cogumm[dot]net
# Telegram: http://t.me/CoGUMm
# Script: PlayRadio
# Description: Main play radio file.
#-----------------------------------------------------------#

PlayRadio()
{
    local listen=$(echo "$*" | cut -d"|" -f3)   # Stream service
    local genre=$(echo "$*" | cut -d"|" -f2)    # Genre
    local radio=$(echo "$*" | cut -d"|" -f1)    # Radio name

	# If radio is selected it ends the 'mplayer' process.
    if [ "$listen" ]; then
		kill -9 $(pidof mplayer); else return 0; fi

    # Run the radio LISTEN in the background and redirect the information to the file 'TMP_LISTEN'
    mplayer "$listen" &>$TMP_LISTEN &
    # Local variables.
    local Music RadioName Swap
    # Radio selection status by user.
    local ini=0
    # Awaits connection to the stream server.
    for cont in $(seq 4); do
        echo; sleep 1; done | yad --progress \
                                  --fixed \
                                  --center \
                                  --no-buttons \
                                  --title "$radio" \
                                  --progress-text="Connection '$listen'..." \
                                  --auto-close --pulsate

    # Updates the radio information every 3 seconds and stores the information
    # in 'Music' and 'RadioName'.
    while true
    do
        # Synchronizes 'radio' information.
        Music="$(cat $TMP_LISTEN | grep -i "StreamTitle" | awk 'END {print}' | cut -d'=' -f2- | cut -d';' -f1 | tr -d "['\"]")"
        RadioName="$(cat $TMP_LISTEN | egrep -i "^Name" | awk 'END {print}' | cut -d':' -f2-)"

        # if the song has changed or if the radio has been selected by the user,
        # it sends a notification with the information of the new track.
        if [ "$Music" != "$Swap" -o $ini -eq 0 ]; then
            Swap="$Music"                           # Current music.
            Music="${Music:-Desconhecido}"          # 'Unknown' default value.
            RadioName="${RadioName:-Desconhecido}"

            # Send notification.
            notify-send --app-name="shRadio" --icon=$ICON_APP "$Music" "$RadioName"
            ini=1   # Status
        fi
        sleep 3  # N> low cpu
    done
}

PlayRadio
# End
