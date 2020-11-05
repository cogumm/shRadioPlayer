#!/bin/bash
. src/config/config.sh
. src/dependencies.sh

#-----------------------------------------------------------#
# Data: 04 de Novembro de 2020
# Nome: Gabriel F. Vilar (CoGUMm)
# E-mail: gabriel[at]cogumm[dot]net
# Telegram: http://t.me/CoGUMm
# Script: shRadio
# Descrição: Script para escutar radio online via bash.
# Variáveis: 
#-----------------------------------------------------------#

# Suprimir erros
exec 2>/dev/null

# Cria uma trap, se o script for interrompido pelo usuário
trap '_exit' TERM INT

# Encerra script
function _exit()
{
	# Apaga arquivo temporário
	rm -f $TMP_LISTEN
	# Mata os subshell's e shell principal
	kill -9 $(pidof mplayer yad) \
			$(ps aux | grep -v grep | grep "$SCRIPT" | grep -v "$$" | awk '{print $2}') &>/dev/null

	exit 0
}

. src/PlayRadio.sh
. src/main.sh

