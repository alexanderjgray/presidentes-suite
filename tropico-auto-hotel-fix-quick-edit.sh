#!/bin/sh

# Watches tropico's save folder for "s-" prefixed (s for scenario) saves and converts them into a FixHotel patched scenario

# Update paths to your specific setup if required. If installed using the Lutris script no alterations should be nessesary.

# Tropico's root folder
DIR="$HOME/Games/gog/tropico/drive_c/GOG Games/Tropico/"

# Tropico's games folder (saves)
GAMES="$DIR/games/"

# Tropico's maps folder (scenarios)
MAPS="$DIR/maps/"

# where is the FixHotel folder and other extras
FIXHOTEL="$HOME/Games/gog/tropico/extras/FixHotel"

inotifywait -m -e moved_to -e create "$GAMES" --format "%f" | while read f
do
    if [[ $f = s-*.GM2 ]]; then
	cd "$DIR";
	echo "Moving $f to root dir...";
	mv "$GAMES/$f" "$DIR";
	echo "Getting new file name and renaming...";
	nf=`echo $f | sed 's/\(.*\.\)GM2/\1mp2/'`;
	mdir=`echo $nf | sed 's/.mp2//'`;
	mv "$DIR/$f" "$DIR/"`echo $f | sed 's/\(.*\.\)GM2/\1mp2/'`;
	echo "Extracting $nf ...";
	wineconsole eventget.exe $nf;
	$VISUAL "$DIR/$mdir/name.oth";
	$VISUAL "$DIR/$mdir/desc.oth";
	echo "Getting new map folder name and applying patch...";
	cp -r "$FIXHOTEL" "$DIR/$mdir";
	echo "Recompiling $nf ...";
	wineconsole eventadd.exe $nf;
	mv $nf "$MAPS";
    fi
done
