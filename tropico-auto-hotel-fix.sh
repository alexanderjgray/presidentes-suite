#!/bin/bash

# Watches tropico's save folder for "s-" prefixed (s for scenario) saves and converts them into a FixHotel patched scenario

# Fetch full absolute path to the scripts location, save it, and goto the directroy
PATH_TO_SCRIPT=$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")");
cd "$PATH_TO_SCRIPT";

inotifywait -m -e moved_to -e create "games" --format "%f" | while read game
do
    if [[ $game = s-*.GM2 ]]; then
	# Convert game file (.GM2) to a map file (.MP2), and move it to the maps folder
	map=`echo $game | sed 's/\(.*\.\)GM2/\1mp2/'`;
	echo "Converting $game into $map ...";
	mv "games/$game" "maps/$map";
	echo "Extracting $map ...";
	wineconsole eventget.exe "maps/$map";
	extracted_map=`echo $map | sed 's/.mp2//'`;
	echo "Getting our extracted maps name: '$extracted_map' and applying the patch ...";
	cp -r "FixHotel" "maps/$extracted_map";
	echo "Recompiling $map ...";
	wineconsole eventadd.exe "maps/$map";
	echo "Cleaning up...";
	rm -r "maps/$extracted_map";
    fi
done
