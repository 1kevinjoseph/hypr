#!/bin/bash
DIR=$HOME/shell-wallpapers/images # Change this to your folder!
PICS=($(ls $DIR))
RANDOM_PIC=${PICS[$RANDOM % ${#PICS[@]}]}

# The transition types: simple, fade, left, right, top, bottom, wipe, wave, grow, center, any
swww img "$DIR/$RANDOM_PIC" --transition-type wipe --transition-step 