#!/usr/bin/env bash



THRESHOLD=5   # hvor mange ganger før du vil ha varsel
WINDOW=600    # 10 min i sekunder

# Hent alle hendelser i dag som root
LOGS=$(sudo ausearch -k passwordstore_access --start today 2>/dev/null)

NOW=$(date +%s)
COUNT=0

while read -r line; do
    if [[ $line == time=* ]]; then
        TS=$(echo "$line" | sed -n 's/.*time->\(.*\)/\1/p')
        EPOCH=$(date -d "$TS" +%s 2>/dev/null)
        if [[ -n $EPOCH ]]; then
            AGE=$((NOW - EPOCH))
            if (( AGE <= WINDOW )); then
                COUNT=$((COUNT + 1))
            fi
        fi
    fi
done <<< "$LOGS"

if (( COUNT > THRESHOLD )); then
    notify-send "Audit Alert" "$COUNT aksesser på .password-store siste 10 min!"
fi
