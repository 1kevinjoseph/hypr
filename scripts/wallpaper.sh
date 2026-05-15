#!/bin/bash

# Configuration
WALL_DIR="$HOME/shell-wallpapers/images"
CACHE_DIR="$HOME/.cache/wallpaper-thumbs"
mkdir -p "$CACHE_DIR"

# 1. Generate thumbnails for Rofi (Crucial for the "Riced" look)
# We use .png for the cache because Rofi handles them better
for img in "$WALL_DIR"/*; do
    filename=$(basename "$img")
    if [ ! -f "$CACHE_DIR/$filename.png" ]; then
        magick "$img" -strip -thumbnail 500x500^ -gravity center -extent 500x500 "$CACHE_DIR/$filename.png"
    fi
done

# 2. Build the list for Rofi
# We format the list so Rofi sees the filename and links it to the icon in cache
list_items=""
for img in "$WALL_DIR"/*; do
    filename=$(basename "$img")
    list_items+="$filename\0icon\x1f$CACHE_DIR/$filename.png\n"
done

# 3. Launch Rofi in Gallery Mode
selected=$(echo -e "$list_items" | rofi -dmenu -i -p "󰸉 Select Wallpaper" \
    -theme-str '
    window { 
        width: 1100px; 
        height: 750px; 
        border: 3px; 
        border-color: #cba6f7; 
        background-color: #1e1e2e; 
        border-radius: 20px;
    }
    mainbox { children: [inputbar, listview]; }
    inputbar { 
        padding: 20px; 
        background-color: #11111b; 
        children: [prompt, entry]; 
    }
    listview { 
        columns: 3; 
        lines: 3; 
        spacing: 25px; 
        padding: 30px; 
        fixed-columns: true;
    }
    element { 
        orientation: vertical; 
        padding: 15px; 
        border-radius: 15px; 
        background-color: transparent;
    }
    element-icon { 
        size: 250px; 
        cursor: pointer;
        horizontal-align: 0.5;
    }
    element-text { 
        horizontal-align: 0.5; 
        padding: 10px 0px 0px 0px;
        font: "JetBrainsMono Nerd Font 10";
    }
    element selected { 
        background-color: #313244; 
        text-color: #89b4fa;
        border: 2px;
        border-color: #89b4fa;
    }
    ')

# 4. Apply selection with the "awww" transition
if [ -n "$selected" ]; then
    awww img "$WALL_DIR/$selected" --transition-type wipe --transition-step 2
fi