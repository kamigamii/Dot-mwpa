#!/usr/bin/env bash

DIR="/home/metalwoopa/Wallpaper"
CACHE_DIR="$DIR/.thumb_cache"

mkdir -p "$CACHE_DIR"

# 1. Toggle mechanism: close if already open
if pgrep -x "rofi" > /dev/null; then
    pkill -x "rofi"
    exit 0
fi

# 2. Process wallpapers and build the Rofi feed
SELECTION=$(find "$DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) | sort | while read -r img; do
    filename=$(basename "$img")
    thumb="$CACHE_DIR/$filename"

    if [ ! -f "$thumb" ]; then
        ffmpeg -v error -i "$img" -vf "
            scale='max(800,iw*450/ih)':'max(450,ih*800/iw)',
            crop=800:450,
            geq=r='r(X,Y)':g='g(X,Y)':b='b(X,Y)':a='if(
                lt(X,30)*lt(Y,30)*gt(sqrt(pow(30-X,2)+pow(30-Y,2)),30) +
                gt(X,800-30)*lt(Y,30)*gt(sqrt(pow(X-(800-30),2)+pow(30-Y,2)),30) +
                lt(X,30)*gt(Y,450-30)*gt(sqrt(pow(30-X,2)+pow(Y-(450-30),2)),30) +
                gt(X,800-30)*gt(Y,450-30)*gt(sqrt(pow(X-(800-30),2)+pow(Y-(450-30),2)),30),
                0,255)'" \
            -vframes 1 "$thumb"
    fi

    echo -en "$img\0icon\x1f$thumb\n"
done | rofi -dmenu -p "Wallpaper" -theme-str 'inputbar { enabled: false; }')

# Apply selection via Awww
if [ -n "$SELECTION" ]; then
    awww img "$SELECTION" \
        --outputs "HDMI-A-1" \
        --transition-type wave \
        --transition-fps 60 \
        --transition-step 90

    # Regenerate colors across Vesktop, Kitty, Waybar, and Hyprland
    matugen image "$SELECTION" --source-color-index 1

    # Soft-reload Hyprland (Waybar reloads via matugen post_hook)
    hyprctl reload
fi
