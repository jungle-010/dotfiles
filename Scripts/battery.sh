#!/usr/bin/env bash
LOW=15
CRITICAL=5
FULL=100
LOW_SENT=0
CRIT_SENT=0
FULL_SENT=0
while true; do
    BAT=$(acpi -b | grep -P -o '[0-9]+(?=%)' | head -1)
    STATUS=$(acpi -b | awk '{print $3}' | tr -d ',')
    if [ "$STATUS" = "Charging" ]; then
        LOW_SENT=0
        CRIT_SENT=0
    fi
    if [ "$STATUS" = "Discharging" ]; then
        FULL_SENT=0
    fi
    if [ "$STATUS" = "Discharging" ]; then
        if [ "$BAT" -le "$CRITICAL" ] && [ "$CRIT_SENT" -eq 0 ]; then
            notify-send -u critical "Battery Critical" "Battery at ${BAT}%"
            CRIT_SENT=1
        elif [ "$BAT" -le "$LOW" ] && [ "$LOW_SENT" -eq 0 ]; then
            notify-send -u normal "Battery Low" "Battery at ${BAT}%"
            LOW_SENT=1
        fi
    fi
    if [ "$STATUS" = "Charging" ] && [ "$BAT" -ge "$FULL" ] && [ "$FULL_SENT" -eq 0 ]; then
        notify-send -u normal "Battery Full" "Battery charged to ${BAT}%"
        FULL_SENT=1
    fi
    sleep 60
done
