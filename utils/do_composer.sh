#!/bin/bash

WDIR="$PWD"
echo "Currently in $WDIR"
composer update
DIRECTORIES=($(grep path .gitmodules | sed 's/.*= //' | tr -d '\r'))
for i in "${DIRECTORIES[@]}"
do
    i=$(echo "$i" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    echo "Entering $WDIR/$i"
    cd "$WDIR/$i" || { echo "Failed to change directory to $WDIR/$i"; exit 1; }
    composer update
    cd "$WDIR" || { echo "Failed to change directory back to $WDIR"; exit 1; }
done
echo "All submodules updated"

