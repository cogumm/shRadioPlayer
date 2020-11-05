#!/bin/bash
. src/config.sh
#---------------------------------------------------------------------------#
# Data: 04 de Novembro de 2020
# Nome: Gabriel F. Vilar (CoGUMm)
# E-mail: gabriel[at]cogumm[dot]net
# Telegram: http://t.me/CoGUMm
# Script: mains
# Descrição: Arquivo main do play da radio.
#---------------------------------------------------------------------------#

# Janela principal
main()
{
	###### JANELA PRINCIPAL ######
	janelaPrincipal=$(yad --form \
		--center \
		--width 300 \
		--height 300 \
		--fixed \
		--title "$SCRIPT - by CoGUMm" \
		--image $ICON_APP \
		--text "Seja bem vindo ao <span foreground='red'><b>shRadio</b></span>!
			\nSeu script de Rádio online.
			\nVocẽ irá encontrar os mais diversos gêneros musicais. \nA lista de rádios são obtidas a partir da fonte \n<b>$SITE</b>.
			\n\nPara começar, escolha o seu gẽnero músical, clicando\nno botão <b>Gêneros</b>.
			\nObs: Todas as informações contidas na lista, são\nsincronizadas com a fonte." \
		--field '':LBL '' \
		--field "Defina o número de paginas a serem pesquisadas, \naumentando assim a quantidade de rádios encontradas.
			\n\nObs: Dependendo do valor, a busca poderá demorar um pouco.":LBL '' \
		--field 'Num. paginas para pesquisa:':NUM '1!1..20!1' \
		--button 'Gêneros!gtk-cdrom':0 \
		--button 'Limpar cache!gtk-delete':1 \
		--button 'Sair!gtk-quit':252)

	# Retorno
	RETVAL=$?

	# Se a janela for fechada	
	if [ $RETVAL -eq 252 ]; then
		 _exit
	# Limpar cache
	elif [ $RETVAL -eq 1 ]; then
		limparCache
		
		# Limpa o cache removendo todos os arquivo .list
		# As informações principais das rádios são armazenadas nesses arquivos
		# que ficam localizados na pasta '/tmp'
		# Cada arquivo possue a extensão .list com o prefixo do nome do gênero.
		[ $? -eq 0 ] &&	rm -f /tmp/*.list &>/dev/null
	
		# Função principal	
		main
	fi

	######### LISTA DE GÊNEROS ###############
	# Gera arquivo de cache se ele não existir.
	if [ ! -e $GENRE_LIST ]; then
		# Lê a linha
		while read radio; do
			# Incrementa arquivo especifico ao gênero
			echo "$radio" >> $GENRE_LIST
			echo "# Adicionando: '$radio'"
			sleep 0.1
		# Realiza um dump na 'url', aplica uma 'ER' para obter as tags dos gêneros, alimentando o while
		# com o padrão obtido.
		done < <(curl "$SITE" 2>/dev/null | sed -n 's/class="btn/\n/gp' | sed -n 's/^.*">\(.*\)<\/a>&nbsp;.*$/\1/pg') \
				| sincronizando
	fi
	
	# Lê as informações do arquivo .list redirecionando para 'yad'
	# Armazena saida em 'GENRE' 
	GENRE=$(cat $GENRE_LIST | generos)

	# Se a janela for fechada.
	[ $? -eq 252 ] && main
	
	COUNT=$(echo $janelaPrincipal | cut -d'|' -f3 | cut -d',' -f1)	# Pega o(s) primeiro(s) digito(s) antes da virgula.
	GENRE="${GENRE/|/}"										# Gênero
	RADIO_LIST="/tmp/$GENRE.list"							# Arquivo .list
	tag_genre="$(echo ${GENRE/ /%20} | tr '[:upper:]' '[:lower:]')"		# Se o nome do gênero conter espaço, substitui por Encondig Reference (%20).

	######### LISTA DE RÁDIOS ###############
	# Gera arquivo de cache se ele não existir.
	if [ ! -e "$RADIO_LIST" ]; then
		for pag in $(seq $COUNT); do
			# Lê a linha
			while read radio; do
				# Incrementa arquivo
				echo "$radio" >> "$RADIO_LIST"
				# Envia somente o nome da rádio para o 'progress'
				[ "$(echo $radio | egrep -v "^http|^$GENRE$")" ] && echo "# $radio"
				sleep 0.1
			# A url é alterada dinamicamente
			# Recebendo os valores do "Gênero" e "Página".
			# O dump é realizado na 'url', aplicando uma 'ER' que obtem as tag's que contém o nome das rádios.
			done < <(curl https://www.internet-radio.com/stations/$tag_genre/page$pag 2>/dev/null | \
					 sed -n "s/^.*?mount=\(.*\)\/listen.*title=\(.*\)&.*$/\2\n$GENRE\n\1/pg") | \
						buscaGeneros
		done  
	fi
	
	# Mata todos os subshell's com excessão do shell principal.
    kill -9 $(ps aux | grep "$SCRIPT" | egrep -v "grep|$$" | awk '{print $2}') &>/dev/null
	
	# Executa a música selecionada em segundo plano.
	PlayRadio $(cat "$RADIO_LIST" \
					|  yad --center \
							--title "Rádios" \
							--fixed \
							--text "<b>Total: $(($(cat "$RADIO_LIST" | wc -l)/3))</b>" \
							--width 600 --height 600  \
							--on-top \
							--no-buttons \
							--list \
							--listen \
							--search-column 1 \
							--hide-column 3 \
							--column "Nome" \
							--column "Gênero" \
							--column "Listen" \
							--separator='|') &
    main
}

main
# Fim