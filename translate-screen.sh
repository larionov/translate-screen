#!/bin/bash

# Source: https://github.dev/larionov/translate-screen

# Quick language menu, add more if you need other languages.
OCR_LANG=$(tesseract --list-langs | tail -n +2 | rofi -me-select-entry '' -hover-select -me-accept-entry 'MousePrimary' -sort true -sorting-method fzf -dmenu -i -p Select OCR anguage)

# Exit if cancelled selection
[ "$OCR_LANG" ] || exit

# prepare temporary file name
SCR_IMG=`mktemp`
trap "rm $SCR_IMG*" EXIT

# take the screenshot
maim -s $SCR_IMG.png #| xclip -selection clipboard -t image/png -i

# Uncomment if on resolution <= 1980p (1K), it should increase detection rate
# mogrify -modulate 100,0 -resize 400% $SCR_IMG.png

# run OCR
tesseract --psm 3 --oem 1 -l $OCR_LANG $SCR_IMG.png $SCR_IMG

# translate and display the results
kitty -o font_size=18 --hold trans -b -show-alternatives no -i $SCR_IMG.txt

exit
