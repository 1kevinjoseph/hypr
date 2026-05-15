# Example snippet for songdetails.sh
# Extract dominant color (requires ImageMagick)
ART_PATH="/tmp/current_art.jpg"
playerctl metadata mpris:artUrl | sed 's|file://||' > "$ART_PATH"
COLOR=$(magick "$ART_PATH" -scale 1x1! -format '%[pixel:u]' info:- | magick - -format "#%02x%02x%02x" info:-)

# Output formatted text
echo "<span foreground='$COLOR'>$(playerctl metadata --format '{{title}} - {{artist}}')</span>"