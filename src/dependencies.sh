#!/bin/bash

#---------------------------------------------------------------------------#
# Data: 04 de Novembro de 2020
# Nome: Gabriel F. Vilar (CoGUMm)
# E-mail: gabriel[at]cogumm[dot]net
# Telegram: http://t.me/CoGUMm
# Script: dependencies
# Descrição: Arquivo das dependencias do projeto.
#---------------------------------------------------------------------------#

dependences() {
    bash src/testConnection.sh

    dependences=$(dpkg --get-selections | grep -c mplayer | grep -c yad | grep -c curl)
    if [ which -a dependences ]
    then
        yad --image=gtk-dialog-question \
            --title "Instalador de dependências." \
            --text "Programas de dependências do projeto já instalados." $configYadB
    else
        yad --image=gtk-dialog-question \
            --title "Instalador de dependências." \
            --text "Instalando as dependências do projeto!" $configYadB
        sudo apt install mplayer -y
        sudo apt install yad -y
        sudo apt install curl -y
    fi

    yad --image=gtk-dialog-question \
        --title "Instalador de dependências." \
        --text "Os programas de dependências do projeto já estão instalados." $configYadB
    return
}

dependences
# Fim