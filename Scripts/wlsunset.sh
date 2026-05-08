#!/bin/bash
PIDFILE="/tmp/wlsunset_4100.pid"
if [ -f "$PIDFILE" ] && kill -0 $(cat "$PIDFILE") 2>/dev/null; then
    kill $(cat "$PIDFILE")
    rm "$PIDFILE"
    echo "wlsunset OFF"
else
    wlsunset -T 4100 &
    echo $! > "$PIDFILE"
    echo "wlsunset ON"
fi
