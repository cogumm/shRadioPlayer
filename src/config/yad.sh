#!/bin/bash

#-----------------------------------------------------------#
# Date: November 05, 2020
# Name: Gabriel F. Vilar (CoGUMm)
# Email: gabriel[at]cogumm[dot]net
# Telegram: http://t.me/CoGUMm
# Script: yad
# Description: Yad settings file.
#-----------------------------------------------------------#

# Icon used in the project.
ICON_APP=/usr/share/icons/HighContrast/48x48/emblems/emblem-music.png

# Window without buttons.
configYad="--width=500
		   --text-align=fill
		   --center
		   --no-buttons
		   --timeout 3"

# Window with CANCEL and OK buttons.
configYadB="--width=500
		   --text-align=center
		   --center
		   --timeout 3"

# Main window.
### BUG 😞 ###
# janelaPrincipal()
# {
#        janelaPrincipal=$(yad --form \
#            --center \
#            --width 300 \
#            --height 300 \
#            --fixed \
#            --title "$SCRIPT - by CoGUMm" \
#            --image $ICON_APP \
#            --text "Welcome to the <span foreground='red'><b>shRadio</b></span>!
#                \nYour Online Radio script.
#                \nYou will find the most diverse musical genres. \nThe radio list is obtained from the source: \n<b>$SITE</b>.
#                \n\nTo start, choose your music genre by clicking \non the button <b>Genre</b>.
#                \nNote: All information contained in the list is \nsyncronized with the source." \
#            --field '':LBL '' \
#            --field "Define the number of pages to be searched, \nthus incrasing the number of radios found.
#                \n\nNote: Depending on the value, the search may \ntake a while.\n\n":LBL '' \
#            --field 'Pages to a search:':NUM '1!1..20!1' \
#            --button 'Genres!gtk-cdrom':0 \
#            --button 'Clear cache!gtk-delete':1 \
#            --button 'Exit!gtk-quit':252)
# }
### BUG 😞 ###

# Janela de sincronização das estações.
sincronizando()
{
    yad --title Gêneros \
        --text "Synchronizing music genres..." \
        --center \
        --no-buttons \
        --auto-kill \
        --auto-close \
        --fixed \
        --width=400 \
        --progress \
        --text-progress \
        --pulsate
}

# Window to clear the application cache.
limparCache()
{
    yad --form \
        --image=gtk-dialog-question \
        --center \
        --fixed \
        --title "Clear cache" \
        --text "This action will clear the entire cache of \nradio lists generated previously.
                \n\nDo you wish to continue ?" \
        --button "Yes":0 --button "No":252
}

# Genres window.
generos()
{
    yad --title "Genres" \
        --center \
        --no-buttons \
        --width=300 \
        --height=600 \
        --no-buttons \
        --text "<b>Total genres found: $(cat "$GENRE_LIST" | wc -l)</b>" \
        --list \
        --search-column 1 \
        --listen \
        --column "Name"
}

# Janela de busca de gêneros.
buscaGeneros()
{
    yad --title "Radio" \
        --text "Genre: <b>$GENRE</b>\Page: <b>$pag</b>\nSearching..." \
        --center \
        --on-top \
        --no-buttons \
        --progress \
        --text-progress \
        --auto-kill \
        --auto-close \
        --fixed \
        --width=600 \
        --pulsate
}

# Play window in the background.
### BUG 😞 ###
# play()
# {
#     yad --center \
#         --title "Rádios" \
#         --fixed \
#         --text "<b>Total: $(($(cat "$RADIO_LIST" | wc -l)/3))</b>" \
#         --width=600
#         --height=600  \
#         --on-top \
#         --no-buttons \
#         --list \
#         --listen \
#         --search-column 1 \
#         --hide-column 3 \
#         --column "Nome" \
#         --column "Gênero" \
#         --column "Listen" \
#         --separator='|'
# }
### BUG 😞 ###
