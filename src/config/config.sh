#!/bin/bash
clear
#---------------------------------------------------------------------------#
# Data: 06 de Setembro de 2017
# Última alteração: 15 de Novembro de 2020
# Nome: Gabriel F. Vilar (CoGUMm)
# E-mail: gabriel[at]cogumm[dot]net
# Telegram: http://t.me/CoGUMm
# Script: config
# Descrição: Arquivo de configuraçõs da aplicação (s2 DRY KISS s2).
#---------------------------------------------------------------------------#

# Script
SCRIPT="$(basename "$0")"

# Variáveis do projeto.
TMP_LISTEN=$(mktemp --tmpdir=/tmp shradio.XXXXXXXXXX)
SITE=https://www.internet-radio.com
GENRE_LIST=/tmp/genres.list

# Arquivo de configurações e textos das janelas.
. src/config/yad.sh

# Cabeçalho de todos os scripts.
head(){
   echo "------------------------------------------------------------------"
   echo "Idealizador e desenvolvedor: Gabriel F. Vilar (CoGUMm)"
   echo "E-mail: gabriel[at]cogumm[dot]net"
   echo "Telegram: http://t.me/CoGUMm"
   echo "Website: http://cogumm.net"
   echo "NÃO ME RESPONSABILIZO POR MAUS DANOS À SUA MÁQUINA COM ESTE SCRIPT,"
   echo "FAVOR UTILIZÁ-LO SE APENAS TIVER CERTEZA DO QUE ESTEJA FAZENDO."
   echo "------------------------------------------------------------------"
}

head
# Fim