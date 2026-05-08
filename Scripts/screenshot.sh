#!/usr/bin/env bash
set -e
DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"
FILE="$DIR/$(date +%Y-%m-%d_%H-%M-%S).png"
mode="$1"
case "$mode" in
    area)
        grim -g "$(slurp -d)" "$FILE"
        ;;
    full)
        grim -o "$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')" "$FILE"
        ;;
    window)
        grim -g "$(
            swaymsg -t get_tree | jq -r '
                .. | select(.focused?) |
                .rect |
                "\(.x),\(.y) \(.width)x\(.height)"
            '
        )" "$FILE"
        ;;
    *)
        echo "incorrect usage you wanker: screenshot.sh [area|full|window]"
        exit 1
        ;;
esac
wl-copy < "$FILE"
if notify-send \
    "Screenshot saved and copied to clipboard" \
    "Middle click to open in Satty\n$FILE" \
    --action="edit=Open in Satty" | grep -q edit; then
    /home/jungle/.cargo/bin/satty --filename "$FILE"
fi
