#!/bin/bash

# Automatically goes through each scenario, extracts them, applys the hotel fix and recompiles.

PATH_TO_SCRIPT=$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")");
cd "$PATH_TO_SCRIPT";

mv "maps" "maps.bak";
mkdir "maps";
mkdir "working";
cp -r "maps.bak/"* "working";

for map in "working/"*
do
    echo "Extracting $map ...";
    wineconsole eventget.exe "$map";
    extracted_map=`echo $map | sed 's/.mp2//i'`;
    echo "$extracted_map";
    cp -r "FixHotel" "$extracted_map";
    echo "Re-compiling $map ..."
    wineconsole eventadd.exe "$map";
    echo "Moving $map to map dir..."
    mv "$map" "maps";
done
echo "Removing working dir...";
rm -r "working";
echo "Finished.";
