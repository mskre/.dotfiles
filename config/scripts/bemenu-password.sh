
#!/usr/bin/env bash
set -euo pipefail
export BEMENU_BACKEND=wayland

# Farger
BG="#000000"
FG="#cdd6f4"
ACCENT="#33ccff"
INACTIVE="#a6adc8"
HIGHLIGHT_BG="#313244"

# --- Hovedmeny ---
mode=$(printf " Username\n󰌋 Password\n🔢 TOTP" \
    | bemenu \
        --prompt "Select mode: " \
        --fn "JetBrainsMono Nerd Font 12" \
        --tb "$BG" --tf "$FG" \
        --hb "$HIGHLIGHT_BG" --hf "$ACCENT" \
        --fb "$BG" --ff "$INACTIVE" \
        --nb "$BG" --nf "$INACTIVE" \
        --ab "$BG" --af "$ACCENT" \
        --sb "$HIGHLIGHT_BG" --sf "$ACCENT" \
        -H 30 \
        --center \
        -W 0.3 \
        -l 3 \
        -i \
        --single-instance)

[ -z "$mode" ] && exit 0

# --- Username / Password ---
if [ "$mode" = " Username" ] || [ "$mode" = "󰌋 Password" ]; then
    choice=$(find -L "$HOME/.password-store" -type f -name '*.gpg' \
        | sed 's:.*/\.password-store/::' \
        | sed 's:\.gpg$::' \
        | sort \
        | sed 's/^/󰌋  /' \
        | bemenu \
            --prompt "$mode from: " \
            --fn "JetBrainsMono Nerd Font 12" \
            --tb "$BG" --tf "$FG" \
            --hb "$HIGHLIGHT_BG" --hf "$ACCENT" \
            --fb "$BG" --ff "$INACTIVE" \
            --nb "$BG" --nf "$INACTIVE" \
            --ab "$BG" --af "$ACCENT" \
            --sb "$HIGHLIGHT_BG" --sf "$ACCENT" \
            -H 30 \
            --center \
            -W 0.5 \
            -l 12 \
            -i \
            --binding vim \
            --vim-esc-exits \
            --single-instance)

    [ -z "$choice" ] && exit 0
    choice=$(echo "$choice" | sed 's/^󰌋  //')
    username=$(basename "$choice")

    if [ "$mode" = " Username" ]; then
        echo -n "$username" | wl-copy --paste-once
        notify-send " Username copied: $username" -t 2000
    else
        password=$(pass show "$choice" | head -n1)
        echo -n "$password" | wl-copy --paste-once
        notify-send " Password copied for $choice" -t 2000
    fi
    exit 0
fi

# --- TOTP ---
if [ "$mode" = "🔢 TOTP" ]; then
    totp_choice=$(ykman oath accounts list \
        | bemenu \
            --prompt "🔢 OTP: " \
            --fn "JetBrainsMono Nerd Font 12" \
            --tb "$BG" --tf "$FG" \
            --hb "$HIGHLIGHT_BG" --hf "$ACCENT" \
            --fb "$BG" --ff "$INACTIVE" \
            --nb "$BG" --nf "$INACTIVE" \
            --ab "$BG" --af "$ACCENT" \
            --sb "$HIGHLIGHT_BG" --sf "$ACCENT" \
            -H 30 \
            --center \
            -W 0.5 \
            -l 12 \
            -i \
            --binding vim \
            --vim-esc-exits \
            --single-instance)

    [ -z "$totp_choice" ] && exit 0

    code=$(ykman oath accounts code "$totp_choice" | awk '{print $NF}')
    if [ -n "$code" ]; then
        echo -n "$code" | wl-copy --paste-once
        notify-send "🔢 TOTP code copied for $totp_choice" -t 2000
    else
        notify-send "❌ Failed to get TOTP for $totp_choice" -t 2000
    fi
    exit 0
fi
sac
