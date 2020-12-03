#!/bin/bash
. src/config/config.sh
. src/dependencies.sh

#-----------------------------------------------------------#
# Data: 04 de Novembro de 2020
# Name: Gabriel F. Vilar (CoGUMm)
# Email: gabriel[at]cogumm[dot]net
# Telegram: http://t.me/CoGUMm
# Script: shRadio
# Description: Script para escutar radio online via bash.
# Variables:
#-----------------------------------------------------------#

# Hide errors.
exec 2>/dev/null

# Creates a system trap if user terminates the script.
trap '_exit' TERM INT

# Closed script
function _exit()
{
	# Remove temporary file
	rm -f $TMP_LISTEN
	# Kill the main and child process of script
	kill -9 $(pidof mplayer yad) \
			$(ps aux | grep -v grep | grep "$SCRIPT" | grep -v "$$" | awk '{print $2}') &>/dev/null

	exit 0
}

. src/PlayRadio.sh
. src/main.sh

