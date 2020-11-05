#!/bin/bash

#---------------------------------------------------------------------------#
# Data: 04 de Novembro de 2020
# Nome: Gabriel F. Vilar (CoGUMm)
# E-mail: gabriel[at]cogumm[dot]net
# Telegram: http://t.me/CoGUMm
# Script: radio
# Descrição: Arquivo do play da radio.
#---------------------------------------------------------------------------#

PlayRadio()
{
    local listen=$(echo "$*" | cut -d"|" -f3)   # Serviço de stream
    local genre=$(echo "$*" | cut -d"|" -f2)    # Gênero
    local radio=$(echo "$*" | cut -d"|" -f1)    # Nome da Radio
	
	# Se rádio for selecionada finaliza o processo 'mplayer'
    if [ "$listen" ]; then
		kill -9 $(pidof mplayer); else return 0; fi

    # Executa o LISTEN da rádio em segundo plano e redireciona as informações para o arquivo 'TMP_LISTEN'
    mplayer "$listen" &>$TMP_LISTEN &
    # Variáveis locais.
    local Music RadioName Swap
    # Status de seleção da rádio pelo usuário
    local ini=0
    # Aguarda conexão com o servidor de stream
    for cont in $(seq 4); do
        echo; sleep 1; done | yad --progress \
                                  --fixed \
                                  --center \
                                  --no-buttons \
                                  --title "$radio" \
                                  --progress-text="Conectando '$listen'..." \
                                  --auto-close --pulsate

    # Atualiza a cada '3' segundos as informações da rádio e armazena as informações em
    # 'Music' e 'RadioName'.
    while true
    do
        # Sincroniza informações da 'rádio'
        Music="$(cat $TMP_LISTEN | grep -i "StreamTitle" | awk 'END {print}' | cut -d'=' -f2- | cut -d';' -f1 | tr -d "['\"]")"
        RadioName="$(cat $TMP_LISTEN | egrep -i "^Name" | awk 'END {print}' | cut -d':' -f2-)"

        # Se a música mudou ou se a rádio foi selecionada pelo usuário, envia uma notificação
        # com as informações da nova faixa.
        if [ "$Music" != "$Swap" -o $ini -eq 0 ]; then
            Swap="$Music"                           # Música atual.
            Music="${Music:-Desconhecido}"          # 'Desconhecido' Valor padrão
            RadioName="${RadioName:-Desconhecido}"

            # Envia notificação
            notify-send --app-name="shRadio" --icon=$ICON_APP "$Music" "$RadioName"
            ini=1   # status
        fi
        sleep 3  # N> low cpu 
    done
}

PlayRadio
# Fim