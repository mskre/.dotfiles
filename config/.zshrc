eval "$(zoxide init zsh)"

alias ffdir='brave "file://$PWD/"'
export STARSHIP_CONFIG="$HOME/.config/starship.toml"
eval "$(starship init zsh)"

dummy_zle_keymap_select() { :; }
zle -N zle-keymap-select dummy_zle_keymap_select
alias dp='brave "https://search.nixos.org/packages"'
alias remoteurl="git remote -v"
alias setremoteurl="git remote set-url origin"

alias d="cd ~/.dotfiles/"
alias rl="sudo nixos-rebuild switch --flake ~/.dotfiles#laptop"
alias rd="sudo nixos-rebuild switch --flake ~/.dotfiles#desktop"
alias c="code . --reuse-window"
alias b="code ~/.zshrc --reuse-window"
alias s="source ~/.zshrc"
alias f="code /home/mikkel/.dotfiles/flake.nix --reuse-window"
alias fgit="git reset --hard HEAD; git clean -fd"
alias ndev="nix develop ~/.dotfiles/"
alias home="s /home/mikkel/.dotfiles/home.nix"

alias conf="code /home/mikkel/.dotfiles --reuse-window"
alias fw="sudo iptables -L -v -n"

alias tfw="sudo journalctl -k | grep -Ei 'DROP|REJECT|iptables|conntrack'"
alias ls='eza --icons=always --group-directories-first'
alias disk='df -h'
alias diskbrukt="dust -d 2 /"
alias t="tmux"
alias lg="lazygit"
alias rebase_main="git pull --rebase origin main"
alias coms="rg -n '^\s*(#|//).*' --no-ignore | rg -v 'https\?://'"
alias sb='git fetch origin; git merge origin/main; git push'

alias diagram="d2 -w -l elk"
#export EDITOR="nvim"

bindkey "\e[1;5D" backward-word   # Ctrl+Left
bindkey "\e[1;5C" forward-word    # Ctrl+Right
# TODO
bindkey '\e[3;5~' kill-word       # Ctrl+Delete


setopt NO_BEEP


typeset -U PATH

if [ -z "$TMUX" ]; then
    tmux attach-session -t main || tmux new-session -s main -f ~/.tmux.conf
fi


export LEDGER_FILE=~/.dotfiles/config/regnskap/regnskap.ledger
source ~/.nix-profile/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.nix-profile/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.nix-profile/share/zsh-vi-mode/zsh-vi-mode.zsh
source ~/.nix-profile/share/fzf-tab/fzf-tab.zsh
source ~/.nix-profile/share/zsh/zsh-autopair/autopair.zsh

fpath+=("/home/mikkel/.nix-profile/share/zsh/site-functions")
# autoload -U compinit && compinit

export PERL5LIB=~/perl5/lib/perl5:$PERL5LIB

export ATUIN_NOBIND="true"
zvm_after_init_commands+=(eval "$(atuin init zsh )")
zvm_after_init_commands+=('bindkey "^r" atuin-search')


rn() {
  (cd "$(git rev-parse --show-toplevel)" && "$@")
}


mount_casio() {
    dev=$(lsblk -o NAME,VENDOR,MODEL | grep -i casio | awk '{print $1}' | head -n 1)
    if [ -z "$dev" ]; then
        echo "Fant ingen CASIO-enhet"
        return 1
    fi
    sudo mkdir -p /mnt
    sudo mount /dev/"$dev"1 /mnt && echo "Casio montert på /mnt"
}

cd_casio_python() {
    cd /mnt/casio/@MainMem/PYTHON || echo "PYTHON-mappe ikke funnet"
}

umount_casio() {
    sync
    sudo umount /mnt && echo "Avmontert /mnt"
}

alias casio_sync='~/.dotfiles/config/casio_sync.sh'

alias kubeconfig="kubectl --kubeconfig=./kubeconfig.yaml"
alias pforwardk="kubectl port-forward svc/auby-service 8080:80 -n production"


alias kstatus="k8s_status"
function k8s_status() {
  local ns="${1:-staging}" 
  echo "Pods:"
  kubectl get pods -n "$ns"

  echo -e "\nDeployments:"
  kubectl get deployments -n "$ns"

  echo -e "\nServices:"
  kubectl get svc -n "$ns"

  echo -e "\nSecrets:"
  kubectl get secrets -n "$ns"

  echo -e "\nPVCs:"
  kubectl get pvc -n "$ns"

  echo -e "\nConfigMaps:"
  kubectl get configmaps -n "$ns"

  echo -e "\nIngress:"
  kubectl get ingress -n "$ns"
}

alias klogs="k8s_logs"
function k8s_logs() {
  local ns="${1:-staging}"
  echo -e "\nNamespace: $ns"
  echo "--------------------------"

  local app_pod=$(kubectl get pods -n "$ns" -l app=auby-app -o jsonpath="{.items[0].metadata.name}")
  local db_pod=$(kubectl get pods -n "$ns" -l app=postgres -o jsonpath="{.items[0].metadata.name}")

  if [[ -z "$app_pod" || -z "$db_pod" ]]; then
    echo "Kunne ikke finne app- eller postgres-pod i namespace $ns."
    return 1
  fi

  echo -e "\nAuby-app logg (pod: $app_pod)"
  echo "--------------------------"
  kubectl logs "$app_pod" -n "$ns" --tail=50

  echo -e "\nPostgres logg (pod: $db_pod)"
  echo "--------------------------"
  kubectl logs "$db_pod" -n "$ns" --tail=50

  echo -e "\nEvents fra $app_pod"
  kubectl describe pod "$app_pod" -n "$ns" | grep -A 10 "Events:"

  echo -e "\nEvents fra $db_pod"
  kubectl describe pod "$db_pod" -n "$ns" | grep -A 10 "Events:"
}

alias pf-auby="k8s_port_forward"

function k8s_port_forward() {
  local ns="${1:-staging}"  
  echo "Starter port-forward til auby-app i namespace '$ns'..."
  kubectl port-forward service/auby-app 8000:80 -n "$ns"
}

clip() {
  local last_hash=""
  local save_dir="$(pwd)"
  echo "📋 Lytter etter nye bilder i clipboard... Lagres i: $save_dir"

  while true; do
    if wl-paste --list-types | grep -q "image/png"; then
      current=$(wl-paste --type image/png | sha256sum | cut -d' ' -f1)

      if [[ "$current" != "$last_hash" ]]; then
        echo -n "📝 Navn på bildet (trykk Enter for timestamp): "
        read name

        if [[ -z "$name" ]]; then
          name="screenshot_$(date +%s)"
        fi

        filename="$save_dir/${name}.png"
        wl-paste --type image/png > "$filename"
        echo "✅ Lagret: $filename"
        last_hash="$current"
      fi
    fi

    sleep 1
  done
}

clip2latex() {
  local save_dir="$(pwd)"
  local rel_path="$1"   
  local last_hash=""

  if [[ -z "$rel_path" ]]; then
    echo "❌ Du må spesifisere path relativt til LaTeX-prosjektet, f.eks. backend/images/minebilder"
    return 1
  fi

  echo "📋 Lytter etter nye bilder i clipboard... Lagres i: $save_dir"

  while true; do
    # Sjekk tilgjengelige bilde-typer
    mime=$(wl-paste --list-types | grep -m1 "image/")
    if [[ -n "$mime" ]]; then
      current=$(wl-paste --type "$mime" | sha256sum | cut -d' ' -f1)

      if [[ "$current" != "$last_hash" ]]; then
        echo -n "📝 Navn på bildet (trykk Enter for timestamp): "
        read name

        if [[ -z "$name" ]]; then
          name="screenshot_$(date +%s)"
        fi

        filename="${name}.png"
        filepath="$save_dir/$filename"

        wl-paste --type "$mime" > "$filepath"
        echo "✅ Lagret: $filepath"
        last_hash="$current"

        base_name="${filename%.*}"
        label="fig:${base_name// /_}"
        caption="${base_name//_/ }"

        latex_block=$(cat <<EOF
\\begin{figure}[H]
    \\centering
    \\includegraphics[width=0.8\\linewidth]{$rel_path/$filename}
    \\caption{$caption}
    \\label{$label}
\\end{figure}
EOF
)

        printf "%s\n" "$latex_block"

        printf "%s\n" "$latex_block" | wl-copy
        echo "📋 LaTeX-kode kopiert til clipboard"
      fi
    fi
    sleep 1
  done
}



export PATH="$HOME/.local/bin:$PATH"

export XCOMPOSEFILE=$HOME/.XCompose
export XMODIFIERS=@im=none


export TERM=screen-256color
export COLORTERM=truecolor

export PATH=$PATH:$HOME/.maestro/bin

eval "$(direnv hook zsh)"

export QEMU_NET_OPTS="hostfwd=tcp:127.0.0.1:2222-:22"

alias startvm='(cd /home/mikkel/.dotfiles && ./result/bin/run-pentest-vm-vm -display none) >/tmp/pentest-vm.log 2>&1 & disown'
alias stopvm='kill $(pgrep -f qemu-system-x86_64)'
export TASKRC=$HOME/.task/config



unalias usb-mount 2>/dev/null
unalias usb-unmount 2>/dev/null

usb-mount() {
  dev=$(lsblk -nrpo NAME,RM,TYPE,MOUNTPOINTS | awk '$2 == 1 && $3 == "part" && $4 == "" {print $1; exit}')
  if [ -z "$dev" ]; then
      echo "No unmounted USB partition found."
      return 1
  fi
  sudo mount "$dev" /mnt/usb && echo "Mounted $dev at /mnt/usb" && ls /mnt/usb
}

# Unmount USB (alt som er mountet på /mnt/usb)
usb-unmount() {
  if mount | grep -q "/mnt/usb"; then
      sudo umount /mnt/usb && echo "Unmounted /mnt/usb"
  else
      echo "Nothing mounted at /mnt/usb"
  fi
}