#!/bin/bash

#-----------------------------------------------------------#
# Date: December 05, 2015
# Name: Gabriel F. Vilar (CoGUMm)
# Email: gabriel[at]cogumm[dot]net
# Telegram: http://t.me/CoGUMm
# Script: testConnection
# Description: Test internet connection.
#-----------------------------------------------------------#

testConnection(){
    yad --image=gtk-dialog-question \
        --title "Testing connection" \
        --text "Testing your internet connection before continuing." $configYad

    if ! ping -c 3 www.google.com 1>/dev/null 2>/dev/stdout; then
        yad --title "Testing connection" --text "An error has occurred, please check your network connection." $configYad
        sleep 2
        read -p "Do the connection test again? (y/n):" escolha
        case $escolha in
            y|Y) echo
                testConnection
                ;;
            n|N) echo
                yad --title "Testing connection" --text "Exiting the connection test." $configYad
                sleep 2
                exit
                ;;
        esac
    else
        yad --image=gtk-dialog-question \
            --title "Testing connection" \
            --text "Everything is ok with your connection. \nContinuing with the program." $configYad
        sleep 1
    fi
}

testConnection
# End
