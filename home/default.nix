{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  dotfiles = "/home/mikkel/.dotfiles/config";
  mkSymlink = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
in
{
  xdg.enable = true;

  # Files outside XDG
  home.file = {
    ".zshrc".source = mkSymlink ".zshrc";
    ".tmux.conf".source = mkSymlink "tmux/.tmux.conf";
  };

  # Files under ~/.config via XDG
  xdg.configFile = {
    "ghostty/config".source = mkSymlink "ghostty/config";
    "starship.toml".source = mkSymlink "starship.toml";
    "waybar".source = mkSymlink "waybar";
  };

  home.username = "mikkel";
  home.homeDirectory = "/home/mikkel";
  home.stateVersion = "25.05";
  nixpkgs.config.allowUnfree = true;

  # Symlinks are now configured in hosts/desktop/configuration.nix under home-manager.users.mikkel.home.file

  home.packages = with pkgs; [
    findex
    pgadmin4
    cilium-cli
    kitty
    termius
    vscode
    hashcat
    github-desktop
    spotify
    exploitdb
    virt-manager
    nixfmt-rfc-style
    openstackclient-full
    eduvpn-client
    blueman
    ffuf
    brightnessctl
    dig
    wireshark
    patchelf
    traceroute
    syncthing
    zsh-autopair
    zsh-fzf-tab
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-vi-mode
    zsh-you-should-use
    papirus-icon-theme
    noto-fonts-emoji
    nerd-fonts.jetbrains-mono
    swaynotificationcenter
    libnotify
    grim
    slurp
    perl540Packages.Appcpanminus
    metasploit
    anki
    gcc
    gobuster
    hyprpaper
    hashid
    mpv
    burpsuite
    hyprland-protocols
    unixtools.netstat
    talosctl
    terraform
    texlive.combined.scheme-full
    timewarrior
    ghostty
    python314
    zathura
    cilium-cli
    whatweb
    nmap
    whois
    ledger
    pkg-config
    tmux
    dnsenum
    yazi
    # cargo
    rustup
    atuin
    bat
    bear
    bemenu
    bibata-cursors
    btop
    calcurse
    cloc
    cmus
    d2
    direnv
    vesktop
    dmidecode
    dos2unix
    dust
    emmet-language-server
    entr
    eza
    fd
    file
    fzf
    gcalcli
    gcr
    git
    go
    hyprsunset
    jq
    kubectl
    lazygit
    librewolf
    lsd
    neofetch
    neovim
    pass
    pavucontrol
    qrencode
    ripgrep
    rsync
    scrcpy
    slurp
    starship
    swaybg
    tailscale
    taskwarrior3
    unzip
    vim
    waybar
    wayland
    wayland-protocols
    wget
    xdg-desktop-portal
    xdg-desktop-portal-wlr
    wl-clipboard
    yt-dlp
    zip
    yewtube
    zoxide
    zsh

  ];

  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      screenshots = true;
      clock = true;
      indicator = true;
      indicator-radius = 70;
      indicator-thickness = 5;
      effect-blur = "7x5";
      ring-color = "000000";
      ring-ver-color = "ffffff";
      ring-wrong-color = "ffffff";
      line-color = "000000";
      line-ver-color = "ffffff";
      line-wrong-color = "ffffff";
      inside-color = "000000";
      inside-ver-color = "000000";
      inside-wrong-color = "000000";
      key-hl-color = "222222";
      separator-color = "000000";
      text-color = "ffffff";
      text-ver-color = "ffffff";
      text-wrong-color = "ffffff";
      fade-in = 0.2;
      font = "JetBrainsMono Nerd Font";
      font-size = 18;
    };
  };

  programs.firefox.enable = true;

  home.pointerCursor = {
    name = "Bibata-Modern-Ice";
    size = 24;
    package = pkgs.bibata-cursors;
    gtk.enable = true;
    x11.enable = true;
  };

  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    commandLineArgs = [
      "--disable-features=WebRtcAllowInputVolumeAdjustment --password-store=basic"
    ];
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "brave-browser.desktop";
      "x-scheme-handler/http" = "brave-browser.desktop";
      "x-scheme-handler/https" = "brave-browser.desktop";
    };
  };
}
