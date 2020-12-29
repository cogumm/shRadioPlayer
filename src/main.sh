#!/bin/bash
. src/config.sh
#-----------------------------------------------------------#
# Date: November 04, 2020
# Name: Gabriel F. Vilar (CoGUMm)
# Email: gabriel[at]cogumm[dot]net
# Telegram: http://t.me/CoGUMm
# Script: main
# Description: Main play radio file.
#-----------------------------------------------------------#

# Main window
main()
{
	###### MAIN WINDOW ######
	janelaPrincipal=$(yad --form \
		--center \
		--width 300 \
		--height 300 \
		--fixed \
		--title "$SCRIPT - by CoGUMm" \
		--image $ICON_APP \
		--text "Welcome to the <span foreground='red'><b>shRadio</b></span>!
			\nYour Online Radio script.
			\nYou will find the most diverse musical genres. \nThe radio list is obtained from the source: \n<b>$SITE</b>.
			\n\nTo start, choose your music genre by clicking \non the button <b>Genre</b>.
			\nNote: All information contained in the list is \nsyncronized with the source." \
		--field '':LBL '' \
		--field "Define the number of pages to be searched, \nthus incrasing the number of radios found.
			\n\nNote: Depending on the value, the search may \ntake a while.\n\n":LBL '' \
		--field 'Pages to a search:':NUM '1!1..20!1' \
		--button 'Genres!gtk-cdrom':0 \
		--button 'Clear cache!gtk-delete':1 \
		--button 'Exit!gtk-quit':252)

	# Return
	RETVAL=$?

	# If the window is closed
	if [ $RETVAL -eq 252 ]; then
		 _exit
	# Clear the cache
	elif [ $RETVAL -eq 1 ]; then
		limparCache

		# Clear the cache by removing all files from .list
		# The main radio information is stored in these files
		# which are located in the '/tmp' folder
		# Each file has the extension .list with the prefix of the genus name.
		[ $? -eq 0 ] &&	rm -f /tmp/*.list &>/dev/null

		# Main function
		main
	fi

	######### LIST OF GENRES ###############
	# Generates cache file if it does not exist.
	if [ ! -e $GENRE_LIST ]; then
    	while read radio; do
			# Increments genre-specific file.
			echo "$radio" >> $GENRE_LIST
			echo "# Adding: '$radio'"
			sleep 0.1
		# Perform a dump in the 'url', apply an 'ER' to obtain the
        # tags of the genres, feeding the while with the obtained pattern.
		done < <(curl "$SITE" 2>/dev/null | sed -n 's/class="btn/\n/gp' | sed -n 's/^.*">\(.*\)<\/a>&nbsp;.*$/\1/pg') \
				| sincronizando
	fi

	# Reads information from the .list file redirecting to 'yad'.
	# Stora output in 'GENRE'.
	GENRE=$(cat $GENRE_LIST | genres)

	# If the window is closed
	[ $? -eq 252 ] && main

	COUNT=$(echo $janelaPrincipal | cut -d'|' -f3 | cut -d',' -f1)	# Take the first digit(s) before the comma.
	GENRE="${GENRE/|/}"										        # Genre
	RADIO_LIST="/tmp/$GENRE.list"							        # File .list
	tag_genre="$(echo ${GENRE/ /%20} | tr '[:upper:]' '[:lower:]')"	# If the genre name contains space, replace it with Encondig Reference (%20).

	######### RADIO LIST ###############
	# Generates cache file if it does not exist.
	if [ ! -e "$RADIO_LIST" ]; then
		for pag in $(seq $COUNT); do
			while read radio; do
				# Increments file.
				echo "$radio" >> "$RADIO_LIST"
				# Only send the name of the radio to 'progress'.
				[ "$(echo $radio | egrep -v "^http|^$GENRE$")" ] && echo "# $radio"
				sleep 0.1
			# The 'url' is dynamically changed.
			# Receiving the values of 'Gender' and 'Page'.
			# The dump is carried out in the 'url', applying an 'ER' that obtains the tags that contain the radio names.
			done < <(curl https://www.internet-radio.com/stations/$tag_genre/page$pag 2>/dev/null | \
					 sed -n "s/^.*?mount=\(.*\)\/listen.*title=\(.*\)&.*$/\2\n$GENRE\n\1/pg") | \
						buscaGeneros
		done
	fi

	# Kills all subshells except for the main shell.
    kill -9 $(ps aux | grep "$SCRIPT" | egrep -v "grep|$$" | awk '{print $2}') &>/dev/null

	# Play the selected song in the background.
	PlayRadio $(cat "$RADIO_LIST" \
					|  yad --center \
							--title "Radio" \
							--fixed \
							--text "<b>Total: $(($(cat "$RADIO_LIST" | wc -l)/3))</b>" \
							--width 600 --height 600  \
							--on-top \
							--no-buttons \
							--list \
							--listen \
							--search-column 1 \
							--hide-column 3 \
							--column "Name" \
							--column "Genre" \
							--column "Listen" \
							--separator='|') &
    main
}

main
# End
