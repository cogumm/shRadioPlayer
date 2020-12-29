#!/bin/bash
clear

#---------------------------------------------------------------------------#
# Date: September 06, 2017
# Last update: 15 de Novembro de 2020
# Name: Gabriel F. Vilar (CoGUMm)
# Email: gabriel[at]cogumm[dot]net
# Telegram: http://t.me/CoGUMm
# Script: config
# Description: Application configuration file (s2 DRY KISS s2).
#---------------------------------------------------------------------------#

# Script
SCRIPT="$(basename "$0")"

# Variables
TMP_LISTEN=$(mktemp --tmpdir=/tmp shradio.XXXXXXXXXX)
SITE=https://www.internet-radio.com
GENRE_LIST=/tmp/genres.list

# Importing the file from settings window and texts.
. src/config/yad.sh

# Header of all scripts.
head(){
   echo "---------------------------------------------------------------------"
   echo "Creator and developer: Gabriel F. Vilar (CoGUMm)"
   echo "Email: gabriel[at]cogumm[dot]net"
   echo "Telegram: http://t.me/CoGUMm"
   echo "Website: http://cogumm.net"
   echo "I AM NOT RESPONSIBLE FOR BAD DAMAGE TO YOUR MACHINE WITH THIS SCRIPT,"
   echo "PLEASE USE IT IF YOU ARE JUST SURE WHAT YOU ARE DOING."
   echo "---------------------------------------------------------------------"
}

head
# End
