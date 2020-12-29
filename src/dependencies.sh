#!/bin/bash

#-----------------------------------------------------------#
# Date: November 04, 2020
# Name: Gabriel F. Vilar (CoGUMm)
# Email: gabriel[at]cogumm[dot]net
# Telegram: http://t.me/CoGUMm
# Script: dependencies
# Description: Project dependencies file.
#-----------------------------------------------------------#

dependencies() {
    bash src/testConnection.sh

    dependencies=$(dpkg --get-selections | grep -c mplayer | grep -c yad | grep -c curl)
    if [ which -a dependencies ]
    then
        yad --image=gtk-dialog-question \
            --title "Dependency installer." \
            --text "Project dependency programs already installed." $configYadB
    else
        yad --image=gtk-dialog-question \
            --title "Dependency installer." \
            --text "Installing the project dependencies!" $configYadB
        sudo apt install mplayer -y
        sudo apt install yad -y
        sudo apt install curl -y
    fi

    yad --image=gtk-dialog-question \
        --title "Dependency installer." \
        --text "The project's dependency programs are already installed." $configYadB
    return
}

dependencies
# End
