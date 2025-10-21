
#!/usr/bin/env bash
set -euo pipefail

bemenu-run \
  --prompt "" \
  --fn "JetBrainsMono Nerd Font 12" \
  --tb "#000000" --tf "#cdd6f4" \
  --hb "#313244" --hf "#33ccff" \
  --fb "#000000" --ff "#a6adc8" \
  --nb "#000000" --nf "#a6adc8" \
  --ab "#000000" --af "#33ccff" \
  --sb "#313244" --sf "#33ccff" \
  -H 30 \
  --center \
  -W 0.5 \
  -l 10 \
  --binding vim \
  --vim-esc-exits \
  --single-instance

[ -n "$choice" ] && exec "$choice"
