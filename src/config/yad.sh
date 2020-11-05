#!/bin/bash

#---------------------------------------------------------------------------#
# Data: 05 de Novembro de 2020
# Nome: Gabriel F. Vilar (CoGUMm)
# E-mail: gabriel[at]cogumm[dot]net
# Telegram: http://t.me/CoGUMm
# Script: yad
# Descrição: Arquivo de configurações do yad.
#---------------------------------------------------------------------------#

# Icone utilizado no projeto.
ICON_APP=/usr/share/icons/HighContrast/48x48/emblems/emblem-music.png

# Janela sem botões
configYad="--width=500
		   --text-align=fill
		   --center
		   --no-buttons
		   --timeout 3"

# Janela com botões de CANCELAR e OK.
configYadB="--width=500
		   --text-align=center
		   --center
		   --timeout 3"

# Janela principal;
# janelaPrincipal()
# {
#     yad --form \
# 		--center \
# 		--width=300 \
# 		--height=300 \
# 		--fixed \
# 		--title "$SCRIPT - by CoGUMm" \
# 		--image $ICON_APP \
# 		--text "Seja bem vindo ao <span foreground='red'><b>shRadio</b></span>!
# 			\nSeu script de Rádio online.
# 			\nVocẽ irá encontrar os mais diversos gêneros musicais. \nA lista de rádios são obtidas a partir da fonte \n<b>$SITE</b>.
# 			\n\nPara começar, escolha o seu gẽnero músical, clicando\nno botão '<b>Gêneros</b>'.
# 			\nObs: Todas as informações contidas na lista, são\nsincronizadas com a fonte." \
# 		--field '':LBL '' \
# 		--field "Defina o número de paginas a serem pesquisadas, \naumentando assim a quantidade de rádios encontradas.
# 			\n\nObs: Dependendo do valor, a busca poderá demorar um pouco.":LBL '' \
# 		--field 'Num. paginas para pesquisa:':NUM '1!1..20!1' \
# 		--button 'Gêneros!gtk-cdrom':0 \
# 		--button 'Limpar cache!gtk-delete':1 \
# 		--button 'Sair!gtk-quit':252
# }

# Janela de sincronização das estações.
sincronizando()
{
    yad --title Gêneros \
        --text "Sincronizando gêneros musicais..." \
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

# Janela de limpar o cache da aplicação.
limparCache()
{
    yad --form \
        --image=gtk-dialog-question \
        --center \
        --fixed \
        --title "Limpeza de cache" \
        --text "Essa ação irá limpar todo cache de listas de rádios \ngeradas anteriormente.
                \n\nDeseja continuar ?" \
        --button "Sim":0 --button "Não":252
}

# Janela de gêneros.
generos()
{
    yad --title "Gêneros" \
        --center \
        --no-buttons \
        --width=300 \
        --height=600 \
        --no-buttons \
        --text "<b>Total de gêneros encontrados: $(cat "$GENRE_LIST" | wc -l)</b>" \
        --list \
        --search-column 1 \
        --listen \
        --column "Nome"
}

# Janela de busca de gêneros.
buscaGeneros()
{
    yad --title "Rádios" \
        --text "Gênero: <b>$GENRE</b>\nPágina: <b>$pag</b>\nProcurando..." \
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

# Janela do play em segundo plano.
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